#include "ShaderConstants.fxh"
#include "util.fxh"
#include "config.fxh"

struct PS_Input
{
	float4 position : SV_Position;
	float3 cPos : chunked;
	float3 wPos : worldPos;
#ifndef BYPASS_PIXEL_SHADER
	lpfloat4 color : COLOR;
	snorm float2 uv0 : TEXCOORD_0_FB_MSAA;
	snorm float2 uv1 : TEXCOORD_1_FB_MSAA;
#endif

#ifdef FOG
	float4 fogColor : FOG_COLOR;
#endif
};

struct PS_Output
{
	float4 color : SV_Target;
};

#ifdef RSLV
float4 rs(float4 col, float2 p, float3 c){
	p=(fract(p.xz*float2(1,-1))*4.-1.5)*7.;
	float a=31.;float b=17.;float c=31.;
	float d=0.;float s=0.;
	if(.45>=c.r&&c.r>.3 ){a=0.;b=31.;c=0.;}
	if(.5 >=c.r&&c.r>.45){a=23.;b=21.;c=29.;}
	if(.55>=c.r&&c.r>.5 ){a=21.;b=21.;c=31.;}
	if(.58>=c.r&&c.r>.55){a=28.;b=4.;c=31.;}
	if(.6 >=c.r&&c.r>.58){a=29.;b=21.;c=23.;}
	if(.65>=c.r&&c.r>.6 ){a=31.;b=21.;c=23.;}
	if(.7 >=c.r&&c.r>.65){a=16.;b=16.;c=31.;}
	if(.75>=c.r&&c.r>.7 ){a=31.;b=21.;c=31.;}
	if(.78>=c.r&&c.r>.75){a=29.;b=21.;c=31.;}
	if(.8 >=c.r&&c.r>.78){d=1.;}
	if(.85>=c.r&&c.r>.8 ){d=1.;a=0.;b=31.;c=0.;}
	if(.9 >=c.r&&c.r>.85){d=1.;a=23.;b=21.;c=29.;}
	if(.95>=c.r&&c.r>.9 ){d=1.;a=21.;b=21.;c=31.;}
	if(.98>=c.r&&c.r>.95){d=1.;a=28.;b=4.;c=31.;}
	if(1. >=c.r&&c.r>.98){d=1.;a=29.;b=21.;c=23.;}
	for(float i=0.;i<5.;i++){
		a*=.5;b*=.5;c*=.5;
		float ps=step(i,p.y-2.)*step(p.y-2.,i+1.);
		s=lerp(s,1.,step(.2,frac(a))*ps*step(2.+d,p.x)*step(p.x,3.+d));
		s=lerp(s,1.,step(.2,frac(b))*ps*step(3.+d,p.x)*step(p.x,4.+d));
		s=lerp(s,1.,step(.2,frac(c))*ps*step(4.+d,p.x)*step(p.x,5.+d));
		a=floor(a);b=floor(b);c=floor(c);
	}
	s=lerp(s,1.,d*step(2.,p.y)*step(p.y,7.)*step(0.+d,p.x)*step(p.x,1.+d));
	s=lerp(s,.5,step(0.,p.y)*step(p.y,1.)*step(0.,p.x)*step(p.x,7.));
	return mix(col,1.,s);
}
#endif

ROOT_SIGNATURE
void main(in PS_Input PSInput, out PS_Output PSOutput)
{
#ifdef BYPASS_PIXEL_SHADER
    PSOutput.color = float4(0.0f, 0.0f, 0.0f, 0.0f);
    return;
#else

#if USE_TEXEL_AA
	float4 diffuse = texture2D_AA(TEXTURE_0, TextureSampler0, PSInput.uv0 );
#else
	float4 diffuse = TEXTURE_0.Sample(TextureSampler0, PSInput.uv0);
#endif

#ifdef SEASONS_FAR
	diffuse.a = 1.0f;
#endif

#if defined(BLEND)
	diffuse.a *= PSInput.color.a;
#endif

#if !defined(ALWAYS_LIT)&&!defined(NIGHT_VISON)
	diffuse *= TEXTURE_1.Sample(TextureSampler1, PSInput.uv1);
#endif

#ifndef SEASONS
	#if !USE_ALPHA_TEST && !defined(BLEND)
		diffuse.a = PSInput.color.a;
	#endif

	diffuse.rgb *= PSInput.color.rgb;
#endif

#ifdef ALPHA_TEST
	#ifdef RSLV
		if(PSInput.color.b==0.)diffuse = rs(diffuse,PSInput.cPos.xz,PSInput.color.rgb);
	#endif
	#ifdef ALPHA_TO_COVERAGE
		#define ALPHA_THRESHOLD 0.05
	#else
		#define ALPHA_THRESHOLD 0.5
	#endif
	if(diffuse.a < ALPHA_THRESHOLD)
		discard;
#endif

#ifdef SEASONS
	float2 uv = PSInput.color.xy;
	diffuse.rgb *= lerp(1.0f, TEXTURE_2.Sample(TextureSampler2, uv).rgb*2.0f, PSInput.color.b);
	diffuse.rgb *= PSInput.color.aaa;
	diffuse.a = 1.0f;
#endif

#ifdef CHUNK_BORDER
	float3 ce = step(8.-abs(PSInput.cPos-8.),wid);
	float4 cm = {step(.5-abs(frac(PSInput.cPos)-.5),wid*.5),0};
	#ifdef DOT
		cm.a = cm.x*cm.y*cm.z;
	#else
		cm.a = saturate(cm.x+cm.y+cm.z-1.);
	#endif
	#define ca(x) lerp(diffuse.rgb,lerp(1,x.rgb,x.a),x.a)
	diffuse.rgb = lerp(diffuse.rgb,lerp(lerp(lerp(diffuse.rgb,ca(xcol),ce.x*cm.x),ca(ycol),ce.y*cm.y),ca(zcol),ce.z*cm.z),cm.a);
	diffuse.rgb = lerp(lerp(lerp(lerp(diffuse.rgb,xcol.rgb,ce.y*ce.z),ycol.rgb,ce.x*ce.z),zcol.rgb,ce.x*ce.y),1,ce.x*ce.y*ce.z);
	diffuse.a = lerp(diffuse.a,1.,cm.a*min(ce.x+ce.y+ce.z,1.));
#endif

#if !defined(ALPHA_TEST) && !defined(BLEND) && defined(SP_CHECKER)
	float dist = length(PSInput.wPos+float3(0,1,0));
	diffuse.rgb = lerp(diffuse.rgb,spacol.rgb,min(min(step(24.,dist),step(dist,44.)),max(smoothstep(25.,24.,dist),smoothstep(43.,44.,dist))*(1.-spacol.a)+spacol.a)*spacol.a);
	float spf = TEXTURE_1.Sample(TextureSampler1,float2(0,1)).r<=.4158?1.:0.;
	if(PSInput.uv1.y<.46)spf = 1.;
	if(PSInput.uv1.x>.46)spf = -1.;
	if(frac(PSInput.cPos.y+.005)<.01 && spf>=.0)diffuse.rgb = lerp(diffuse.rgb,lerp(spmbcol.rgb,lerp(spmfcol,spmncol,spf),step(distance(float2(.5,.5),frac(PSInput.cPos.xz)),.05)),step(distance(float2(.5,.5),frac(PSInput.cPos.xz)),.07)*spmbcol.a);
#endif

#ifdef FOG
	diffuse.rgb = lerp( diffuse.rgb, PSInput.fogColor.rgb, PSInput.fogColor.a );
#endif

#ifdef COMPASS
	float2 sub = PSInput.position.xy/COMPASS-.5;
	sub.y *= -1.;
	float subl = length(sub);
	if(sub.y<.5){
		float3 col = lerp(diffuse.rgb,1,.5);
		//if(sub.x<-.25)if(WORLDVIEW[0].x>sub.y)col=1;	if(0.<sub.x && sub.x<.25)if(WORLDVIEW[0].z>sub.y)col=1;

		//目盛り
		float2 sub2 = mul(sub,float2x2(.9914,.1305,-.1305,.9914));//pi/24
		float d = 1.;
		for(int i=0; i<12; i++){
			d = min(d,abs(sub2.x));
			sub2 = mul(sub2,float2x2(.9659,.2588,-.2588,.9659));//pi/12
		}
		col = lerp(col,.9,step(.05,d));

		//十字
		sub2 = mul(sub,float2x2(.7071,.7071,-.7071,.7071));
		float cr = max(step(min(abs(sub.x)+abs(sub.y*.1),abs(sub.x*.1)+abs(sub.y)),.05),
			step(min(abs(sub2.x)+abs(sub2.y*.1),abs(sub2.x*.1)+abs(sub2.y)),.045));
		col = lerp(col,float3(0,.5,1),cr*.3);

		//針
		sub = mul(sub,float2x2(WORLDVIEW[0].x,-WORLDVIEW[0].z,WORLDVIEW[0].z,WORLDVIEW[0].x));
		col = lerp(col,lerp(.5,float3(1,0,0),smoothstep(-.1,.1,sub.y)),step(abs(sub.x)+abs(sub.y*.1),.04));

		diffuse.rgb = lerp(diffuse.rgb,col,smoothstep(.5,.47,subl));
	}
#endif

PSOutput.color = diffuse;

#ifdef VR_MODE
	// On Rift, the transition from 0 brightness to the lowest 8 bit value is abrupt, so clamp to
	// the lowest 8 bit value.
	PSOutput.color = max(PSOutput.color, 1 / 255.0f);
#endif

#endif // BYPASS_PIXEL_SHADER
}
