#ifndef UTILCFG
#define UTILCFG

#define NIGHT_VISON
#define RSLV
#define COMPASS 256.0//size

#define CHUNK_BORDER
	/////advanced setting/////
	const float wid = .0626;
	const vec4 xcol = vec4(1,0,0,.5);
	const vec4 ycol = vec4(0,1,0,.0);
	const vec4 zcol = vec4(0,.63,1,.5);
	//#define DOT

#define SP_CHECKER//go terain.fsh l138 for more settings
	/////advanced setting/////
	const vec4 spacol = vec4(1,1,1,0.5);//spawn area color and opacity
	const vec4 spmbcol = vec4(.2,.2,.2,0.5);//spawn marker background color and opacity
	const vec3 spmfcol = vec3(.7);//spawn marker off color
	const vec3 spmncol = vec3(1,1,0);//spawn marker on color

#endif
