// __multiversion__
// This signals the loading code to prepend either #version 100 or #version 300 es as apropriate.

#include "fragmentVersionCentroid.h"

#if __VERSION__ >= 300
	#ifndef BYPASS_PIXEL_SHADER
		#if defined(TEXEL_AA) && defined(TEXEL_AA_FEATURE)
			_centroid in highp vec2 uv0;
			_centroid in highp vec2 uv1;
		#else
			_centroid in vec2 uv0;
			_centroid in vec2 uv1;
		#endif
	#endif
#else
	#ifndef BYPASS_PIXEL_SHADER
		varying vec2 uv0;
		varying vec2 uv1;
	#endif
#endif

varying vec4 color;
varying POS3 cPos;
varying POS3 wPos;
#ifdef FOG
varying vec4 fogColor;
#endif

#include "uniformShaderConstants.h"
#include "util.h"
#include "config.h"
uniform MAT4 WORLDVIEW;

LAYOUT_BINDING(0) uniform sampler2D TEXTURE_0;
LAYOUT_BINDING(1) uniform sampler2D TEXTURE_1;
LAYOUT_BINDING(2) uniform sampler2D TEXTURE_2;

#ifdef RSLV
vec4 rs(vec4 col){
	vec2 p=(fract(cPos.xz*vec2(1,-1))*4.-1.5)*7.;
	float a=31.;float b=17.;float c=31.;
	float d=0.;float s=0.;
	if(.45>=color.r&&color.r>.3 ){a=0.;b=31.;c=0.;}
	if(.5 >=color.r&&color.r>.45){a=23.;b=21.;c=29.;}
	if(.55>=color.r&&color.r>.5 ){a=21.;b=21.;c=31.;}
	if(.58>=color.r&&color.r>.55){a=28.;b=4.;c=31.;}
	if(.6 >=color.r&&color.r>.58){a=29.;b=21.;c=23.;}
	if(.65>=color.r&&color.r>.6 ){a=31.;b=21.;c=23.;}
	if(.7 >=color.r&&color.r>.65){a=16.;b=16.;c=31.;}
	if(.75>=color.r&&color.r>.7 ){a=31.;b=21.;c=31.;}
	if(.78>=color.r&&color.r>.75){a=29.;b=21.;c=31.;}
	if(.8 >=color.r&&color.r>.78){d=1.;}
	if(.85>=color.r&&color.r>.8 ){d=1.;a=0.;b=31.;c=0.;}
	if(.9 >=color.r&&color.r>.85){d=1.;a=23.;b=21.;c=29.;}
	if(.95>=color.r&&color.r>.9 ){d=1.;a=21.;b=21.;c=31.;}
	if(.98>=color.r&&color.r>.95){d=1.;a=28.;b=4.;c=31.;}
	if(1. >=color.r&&color.r>.98){d=1.;a=29.;b=21.;c=23.;}
	for(float i=0.;i<5.;i++){
		a*=.5;b*=.5;c*=.5;
		float ps=step(i,p.y-2.)*step(p.y-2.,i+1.);
		s=mix(s,1.,step(.2,fract(a))*ps*step(2.+d,p.x)*step(p.x,3.+d));
		s=mix(s,1.,step(.2,fract(b))*ps*step(3.+d,p.x)*step(p.x,4.+d));
		s=mix(s,1.,step(.2,fract(c))*ps*step(4.+d,p.x)*step(p.x,5.+d));
		a=floor(a);b=floor(b);c=floor(c);
	}
	s=mix(s,1.,d*step(2.,p.y)*step(p.y,7.)*step(0.+d,p.x)*step(p.x,1.+d));
	s=mix(s,.5,step(0.,p.y)*step(p.y,1.)*step(0.,p.x)*step(p.x,7.));
	return mix(col,vec4(1),s);
}
#endif

void main()
{
#ifdef BYPASS_PIXEL_SHADER
	gl_FragColor = vec4(0, 0, 0, 0);
	return;
#else

#if USE_TEXEL_AA
	vec4 diffuse = texture2D_AA(TEXTURE_0, uv0);
#else
	vec4 diffuse = texture2D(TEXTURE_0, uv0);
#endif

#ifdef SEASONS_FAR
	diffuse.a = 1.0;
#endif

vec4 inColor = color;

#if defined(BLEND)
	diffuse.a *= inColor.a;
#endif

#if !defined(ALWAYS_LIT)&&!defined(NIGHT_VISON)
	diffuse *= texture2D( TEXTURE_1, uv1 );
#endif

#ifndef SEASONS
	#if !USE_ALPHA_TEST && !defined(BLEND)
		diffuse.a = inColor.a;
	#endif
	diffuse.rgb *= inColor.rgb;
#endif

#ifdef ALPHA_TEST
	#ifdef RSLV
		if(color.b==0.)diffuse = rs(diffuse);
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
	vec2 uv = inColor.xy;
	diffuse.rgb *= mix(vec3(1.0,1.0,1.0), texture2D( TEXTURE_2, uv).rgb*2.0, inColor.b);
	diffuse.rgb *= inColor.aaa;
	diffuse.a = 1.0;
#endif

#ifdef CHUNK_BORDER
	vec3 ce = step(8.-abs(cPos-8.),vec3(wid));
	vec4 cm = vec4(step(.5-abs(fract(cPos)-.5),vec3(wid*.5)),0);
	#ifdef DOT
		cm.a = cm.x*cm.y*cm.z;
	#else
		cm.a = clamp(cm.x+cm.y+cm.z-1.,0.,1.);
	#endif
	#define ca(x) mix(diffuse.rgb,mix(vec3(1),x.rgb,x.a),x.a)
	diffuse.rgb = mix(diffuse.rgb,mix(mix(mix(diffuse.rgb,ca(xcol),ce.x*cm.x),ca(ycol),ce.y*cm.y),ca(zcol),ce.z*cm.z),cm.a);
	diffuse.rgb = mix(mix(mix(mix(diffuse.rgb,xcol.rgb,ce.y*ce.z),ycol.rgb,ce.x*ce.z),zcol.rgb,ce.x*ce.y),vec3(1),ce.x*ce.y*ce.z);
	diffuse.a = mix(diffuse.a,1.,cm.a*min(ce.x+ce.y+ce.z,1.));
#endif

#if !defined(ALPHA_TEST) && !defined(BLEND) && defined(SP_CHECKER)
	float dist = length(wPos+vec3(0,1,0));
	diffuse.rgb = mix(diffuse.rgb,spacol.rgb,min(min(step(24.,dist),step(dist,44.)),max(smoothstep(25.,24.,dist),smoothstep(43.,44.,dist))*(1.-spacol.a)+spacol.a)*spacol.a);
	float spf = texture2D(TEXTURE_1,vec2(0,1)).r<=.4158?1.:0.;
	if(uv1.y<.46)spf = 1.;
	if(uv1.x>.46)spf = -1.;
	if(fract(cPos.y+.005)<.01 && spf>=.0)diffuse.rgb = mix(diffuse.rgb,mix(spmbcol.rgb,mix(spmfcol,spmncol,spf),step(distance(vec2(.5),fract(cPos.xz)),.05)),step(distance(vec2(.5),fract(cPos.xz)),.07)*spmbcol.a);
#endif

#ifdef FOG
	diffuse.rgb = mix( diffuse.rgb, fogColor.rgb, fogColor.a );
#endif

#ifdef COMPASS
	vec2 sub = gl_FragCoord.xy/COMPASS-.5;
	float subl = length(sub);
	if(subl<.5){
		vec3 col = mix(diffuse.rgb,vec3(1),.5);
		//if(acos(WORLDVIEW[0].x)/3.1415>sub.y+.5)col=vec3(1);

		//目盛り
		vec2 sub2 = sub*mat2(.9914,.1305,-.1305,.9914);//pi/24
		float d = 1.;
		for(int i=0; i<12; i++){
			d = min(d,abs(sub2.x));
			sub2 *= mat2(.9659,.2588,-.2588,.9659);//pi/12
		}
		col = mix(col,vec3(.9),step(.05,d));

		//十字
		sub2 = sub*mat2(.7071,.7071,-.7071,.7071);
		float cr = max(step(min(abs(sub.x)+abs(sub.y*.1),abs(sub.x*.1)+abs(sub.y)),.05),
			step(min(abs(sub2.x)+abs(sub2.y*.1),abs(sub2.x*.1)+abs(sub2.y)),.045));
		col = mix(col,vec3(0,.5,1),cr*.3);

		//針
		sub *= mat2(WORLDVIEW[0].x,WORLDVIEW[2].x,-WORLDVIEW[2].x,WORLDVIEW[0].x);
		col = mix(col,mix(vec3(.5),vec3(1,0,0),smoothstep(-.1,.1,sub.y)),step(abs(sub.x)+abs(sub.y*.1),.04));

		diffuse.rgb = mix(diffuse.rgb,col,smoothstep(.5,.47,subl));
	}
#endif

gl_FragColor = diffuse;

#endif // BYPASS_PIXEL_SHADER
}
