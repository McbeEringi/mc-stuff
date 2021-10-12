#ifndef UTILCFG
#define UTILCFG

#define NIGHT_VISON
#define RSLV
#define COMPASS 512.0//size

#define CHUNK_BORDER
	/////advanced setting/////
	static float wid = .0626;
	static float4 xcol = {1,0,0,.5};
	static float4 ycol = {0,1,0,.0};
	static float4 zcol = {0,.63,1,.5};
	//#define DOT

#define SP_CHECKER
	/////advanced setting/////
	static const float4 spacol = {1.,1.,1.,0.5};//spawn area color and opacity
	static const float4 spmbcol = {.2,.2,.2,0.5};//spawn marker background color and opacity
	static const float3 spmfcol = {.7,.7,.7};//spawn marker off color
	static const float3 spmncol = {1.,1.,0.};//spawn marker on color

#endif
