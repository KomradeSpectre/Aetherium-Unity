Shader "Hopoo Games/FX/Cloud Intersection Remap" {
	Properties {
		[Enum(UnityEngine.Rendering.BlendMode)] _SrcBlendFloat ("Source Blend", Float) = 1
		[Enum(UnityEngine.Rendering.BlendMode)] _DstBlendFloat ("Destination Blend", Float) = 1
		[HDR] _TintColor ("Tint", Vector) = (1,1,1,1)
		_MainTex ("Base (RGB) Trans (A)", 2D) = "grey" {}
		_Cloud1Tex ("Cloud 1 (RGB) Trans (A)", 2D) = "grey" {}
		_Cloud2Tex ("Cloud 2 (RGB) Trans (A)", 2D) = "grey" {}
		_RemapTex ("Color Remap Ramp (RGB)", 2D) = "grey" {}
		_CutoffScroll ("Cutoff Scroll Speed", Vector) = (0,0,0,0)
		_InvFade ("Soft Factor", Range(0, 30)) = 1
		_SoftPower ("Soft Power", Range(0.1, 20)) = 1
		_Boost ("Brightness Boost", Range(0, 5)) = 1
		_RimPower ("Rim Power", Range(0.1, 20)) = 1
		_RimStrength ("Rim Strength", Range(0, 5)) = 1
		_AlphaBoost ("Alpha Boost", Range(0, 20)) = 1
		_IntersectionStrength ("Intersection Strength", Range(0, 20)) = 0
		[MaterialEnum(Off,0,Front,1,Back,2)] _Cull ("Cull", Float) = 0
		[PerRendererData] _ExternalAlpha ("External Alpha", Range(0, 1)) = 1
		[Toggle(FADE_FROM_VERTEX_COLORS)] _FadeFromVertexColorsOn ("Fade Alpha from Vertex Color Luminance", Float) = 0
		[Toggle(TRIPLANAR)] _TriplanarOn ("Enable Triplanar Projections for Clouds", Float) = 0
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Blend [_SrcBlendFloat] [_DstBlendFloat], [_SrcBlendFloat] [_DstBlendFloat]
			ZWrite Off
			Cull [_Cull]
			CGPROGRAM

#include "UnityCG.cginc"

#pragma vertex vert
#pragma fragment frag

#pragma multi_compile DIRECTIONAL
#pragma multi_compile LIGHTPROBE_SH __
#pragma multi_compile FADE_FROM_VERTEX_COLORS TRIPLANAR __
#pragma multi_compile SHADOWS_SCREEN __
#pragma multi_compile INSTANCING_ON __

#if 1 && defined (DIRECTIONAL) && !defined (LIGHTPROBE_SH) && !defined (FADE_FROM_VERTEX_COLORS) && !defined (TRIPLANAR) && !defined (SHADOWS_SCREEN) && !defined (INSTANCING_ON)

					uniform float4 unused_0_0[12];
					uniform float4 _MainTex_ST;
					uniform float4 _Cloud1Tex_ST;
					uniform float4 _Cloud2Tex_ST;
					struct app_in {
						    float4 in_POSITION0 : POSITION;
						    float3 in_NORMAL0 : NORMAL;
						    float4 in_TEXCOORD1 : TEXCOORD1;
						    float4 in_COLOR0 : COLOR0;
					};
					struct inter {
						float4 vertex : SV_POSITION;
						float4 vs_TEXCOORD0 : TEXCOORD0;
						float2 vs_TEXCOORD1 : TEXCOORD1;
						float3 vs_TEXCOORD2 : TEXCOORD2;
						float3 vs_TEXCOORD3 : TEXCOORD3;
						float4 vs_TEXCOORD4 : TEXCOORD4;
						float4 vs_COLOR0 : COLOR0;
						float4 vs_TEXCOORD5 : TEXCOORD5;
						float4 vs_TEXCOORD6 : TEXCOORD6;
					};
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					inter vert(app_in i)
					{
					    inter o;
					float4 u_xlat0;
					float4 u_xlat1;
					float u_xlat7;
					    u_xlat0 = i.in_POSITION0.yyyy * float4(unity_ObjectToWorld[0][1],unity_ObjectToWorld[1][1],unity_ObjectToWorld[2][1],unity_ObjectToWorld[3][1]);
					    u_xlat0 = float4(unity_ObjectToWorld[0][0],unity_ObjectToWorld[1][0],unity_ObjectToWorld[2][0],unity_ObjectToWorld[3][0]) * i.in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = float4(unity_ObjectToWorld[0][2],unity_ObjectToWorld[1][2],unity_ObjectToWorld[2][2],unity_ObjectToWorld[3][2]) * i.in_POSITION0.zzzz + u_xlat0;
					    u_xlat1 = u_xlat0 + float4(unity_ObjectToWorld[0][3],unity_ObjectToWorld[1][3],unity_ObjectToWorld[2][3],unity_ObjectToWorld[3][3]);
					    o.vs_TEXCOORD3.xyz = float4(unity_ObjectToWorld[0][3],unity_ObjectToWorld[1][3],unity_ObjectToWorld[2][3],unity_ObjectToWorld[3][3]).xyz * i.in_POSITION0.www + u_xlat0.xyz;
					    u_xlat0 = u_xlat1.yyyy * float4(unity_MatrixVP[0][1],unity_MatrixVP[1][1],unity_MatrixVP[2][1],unity_MatrixVP[3][1]);
					    u_xlat0 = float4(unity_MatrixVP[0][0],unity_MatrixVP[1][0],unity_MatrixVP[2][0],unity_MatrixVP[3][0]) * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = float4(unity_MatrixVP[0][2],unity_MatrixVP[1][2],unity_MatrixVP[2][2],unity_MatrixVP[3][2]) * u_xlat1.zzzz + u_xlat0;
					    u_xlat0 = float4(unity_MatrixVP[0][3],unity_MatrixVP[1][3],unity_MatrixVP[2][3],unity_MatrixVP[3][3]) * u_xlat1.wwww + u_xlat0;
					    o.vertex = u_xlat0;
					    o.vs_TEXCOORD0.xy = i.in_TEXCOORD1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    o.vs_TEXCOORD0.zw = i.in_TEXCOORD1.xy * _Cloud1Tex_ST.xy + _Cloud1Tex_ST.zw;
					    o.vs_TEXCOORD1.xy = i.in_TEXCOORD1.xy * _Cloud2Tex_ST.xy + _Cloud2Tex_ST.zw;
					    u_xlat1.x = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][0],unity_WorldToObject[1][0],unity_WorldToObject[2][0],unity_WorldToObject[3][0]).xyz);
					    u_xlat1.y = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][1],unity_WorldToObject[1][1],unity_WorldToObject[2][1],unity_WorldToObject[3][1]).xyz);
					    u_xlat1.z = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][2],unity_WorldToObject[1][2],unity_WorldToObject[2][2],unity_WorldToObject[3][2]).xyz);
					    u_xlat7 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat7 = rsqrt(u_xlat7);
					    o.vs_TEXCOORD2.xyz = u_xlat7 * u_xlat1.xyz;
					    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
					    u_xlat1.xzw = u_xlat0.xwy * float3(0.5, 0.5, 0.5);
					    o.vs_TEXCOORD4.zw = u_xlat0.zw;
					    o.vs_TEXCOORD4.xy = u_xlat1.zz + u_xlat1.xw;
					    o.vs_COLOR0 = i.in_COLOR0;
					    o.vs_TEXCOORD5 = float4(0.0, 0.0, 0.0, 0.0);
					    o.vs_TEXCOORD6 = float4(0.0, 0.0, 0.0, 0.0);
					    return o;
					}

#endif

#if 1 && defined (DIRECTIONAL) && defined (LIGHTPROBE_SH) && defined (FADE_FROM_VERTEX_COLORS) && !defined (TRIPLANAR) && !defined (SHADOWS_SCREEN) && !defined (INSTANCING_ON)

					uniform float4 unused_0_0[12];
					uniform float4 _MainTex_ST;
					uniform float4 _Cloud1Tex_ST;
					uniform float4 _Cloud2Tex_ST;
					struct app_in {
						    float4 in_POSITION0 : POSITION;
						    float3 in_NORMAL0 : NORMAL;
						    float4 in_TEXCOORD1 : TEXCOORD1;
						    float4 in_COLOR0 : COLOR0;
					};
					struct inter {
						float4 vertex : SV_POSITION;
						float4 vs_TEXCOORD0 : TEXCOORD0;
						float2 vs_TEXCOORD1 : TEXCOORD1;
						float3 vs_TEXCOORD2 : TEXCOORD2;
						float3 vs_TEXCOORD3 : TEXCOORD3;
						float4 vs_TEXCOORD4 : TEXCOORD4;
						float4 vs_COLOR0 : COLOR0;
						float4 vs_TEXCOORD5 : TEXCOORD5;
						float4 vs_TEXCOORD6 : TEXCOORD6;
					};
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					inter vert(app_in i)
					{
					    inter o;
					float4 u_xlat0;
					float4 u_xlat1;
					float u_xlat7;
					    u_xlat0 = i.in_POSITION0.yyyy * float4(unity_ObjectToWorld[0][1],unity_ObjectToWorld[1][1],unity_ObjectToWorld[2][1],unity_ObjectToWorld[3][1]);
					    u_xlat0 = float4(unity_ObjectToWorld[0][0],unity_ObjectToWorld[1][0],unity_ObjectToWorld[2][0],unity_ObjectToWorld[3][0]) * i.in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = float4(unity_ObjectToWorld[0][2],unity_ObjectToWorld[1][2],unity_ObjectToWorld[2][2],unity_ObjectToWorld[3][2]) * i.in_POSITION0.zzzz + u_xlat0;
					    u_xlat1 = u_xlat0 + float4(unity_ObjectToWorld[0][3],unity_ObjectToWorld[1][3],unity_ObjectToWorld[2][3],unity_ObjectToWorld[3][3]);
					    o.vs_TEXCOORD3.xyz = float4(unity_ObjectToWorld[0][3],unity_ObjectToWorld[1][3],unity_ObjectToWorld[2][3],unity_ObjectToWorld[3][3]).xyz * i.in_POSITION0.www + u_xlat0.xyz;
					    u_xlat0 = u_xlat1.yyyy * float4(unity_MatrixVP[0][1],unity_MatrixVP[1][1],unity_MatrixVP[2][1],unity_MatrixVP[3][1]);
					    u_xlat0 = float4(unity_MatrixVP[0][0],unity_MatrixVP[1][0],unity_MatrixVP[2][0],unity_MatrixVP[3][0]) * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = float4(unity_MatrixVP[0][2],unity_MatrixVP[1][2],unity_MatrixVP[2][2],unity_MatrixVP[3][2]) * u_xlat1.zzzz + u_xlat0;
					    u_xlat0 = float4(unity_MatrixVP[0][3],unity_MatrixVP[1][3],unity_MatrixVP[2][3],unity_MatrixVP[3][3]) * u_xlat1.wwww + u_xlat0;
					    o.vertex = u_xlat0;
					    o.vs_TEXCOORD0.xy = i.in_TEXCOORD1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    o.vs_TEXCOORD0.zw = i.in_TEXCOORD1.xy * _Cloud1Tex_ST.xy + _Cloud1Tex_ST.zw;
					    o.vs_TEXCOORD1.xy = i.in_TEXCOORD1.xy * _Cloud2Tex_ST.xy + _Cloud2Tex_ST.zw;
					    u_xlat1.x = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][0],unity_WorldToObject[1][0],unity_WorldToObject[2][0],unity_WorldToObject[3][0]).xyz);
					    u_xlat1.y = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][1],unity_WorldToObject[1][1],unity_WorldToObject[2][1],unity_WorldToObject[3][1]).xyz);
					    u_xlat1.z = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][2],unity_WorldToObject[1][2],unity_WorldToObject[2][2],unity_WorldToObject[3][2]).xyz);
					    u_xlat7 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat7 = rsqrt(u_xlat7);
					    o.vs_TEXCOORD2.xyz = u_xlat7 * u_xlat1.xyz;
					    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
					    u_xlat1.xzw = u_xlat0.xwy * float3(0.5, 0.5, 0.5);
					    o.vs_TEXCOORD4.zw = u_xlat0.zw;
					    o.vs_TEXCOORD4.xy = u_xlat1.zz + u_xlat1.xw;
					    o.vs_COLOR0 = i.in_COLOR0;
					    o.vs_TEXCOORD5 = float4(0.0, 0.0, 0.0, 0.0);
					    o.vs_TEXCOORD6 = float4(0.0, 0.0, 0.0, 0.0);
					    return o;
					}

#endif

#if 1 && defined (DIRECTIONAL) && defined (LIGHTPROBE_SH) && !defined (FADE_FROM_VERTEX_COLORS) && defined (TRIPLANAR) && !defined (SHADOWS_SCREEN) && !defined (INSTANCING_ON)

					uniform float4 unused_0_0[14];
					uniform float4 _MainTex_ST;
					struct app_in {
						    float4 in_POSITION0 : POSITION;
						    float3 in_NORMAL0 : NORMAL;
						    float4 in_TEXCOORD1 : TEXCOORD1;
						    float4 in_COLOR0 : COLOR0;
					};
					struct inter {
						float4 vertex : SV_POSITION;
						float2 vs_TEXCOORD0 : TEXCOORD0;
						float3 vs_TEXCOORD1 : TEXCOORD1;
						float3 vs_TEXCOORD2 : TEXCOORD2;
						float4 vs_TEXCOORD3 : TEXCOORD3;
						float4 vs_COLOR0 : COLOR0;
						float4 vs_TEXCOORD4 : TEXCOORD4;
						float4 vs_TEXCOORD5 : TEXCOORD5;
					};
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					inter vert(app_in i)
					{
					    inter o;
					float4 u_xlat0;
					float4 u_xlat1;
					float u_xlat7;
					    u_xlat0 = i.in_POSITION0.yyyy * float4(unity_ObjectToWorld[0][1],unity_ObjectToWorld[1][1],unity_ObjectToWorld[2][1],unity_ObjectToWorld[3][1]);
					    u_xlat0 = float4(unity_ObjectToWorld[0][0],unity_ObjectToWorld[1][0],unity_ObjectToWorld[2][0],unity_ObjectToWorld[3][0]) * i.in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = float4(unity_ObjectToWorld[0][2],unity_ObjectToWorld[1][2],unity_ObjectToWorld[2][2],unity_ObjectToWorld[3][2]) * i.in_POSITION0.zzzz + u_xlat0;
					    u_xlat1 = u_xlat0 + float4(unity_ObjectToWorld[0][3],unity_ObjectToWorld[1][3],unity_ObjectToWorld[2][3],unity_ObjectToWorld[3][3]);
					    o.vs_TEXCOORD2.xyz = float4(unity_ObjectToWorld[0][3],unity_ObjectToWorld[1][3],unity_ObjectToWorld[2][3],unity_ObjectToWorld[3][3]).xyz * i.in_POSITION0.www + u_xlat0.xyz;
					    u_xlat0 = u_xlat1.yyyy * float4(unity_MatrixVP[0][1],unity_MatrixVP[1][1],unity_MatrixVP[2][1],unity_MatrixVP[3][1]);
					    u_xlat0 = float4(unity_MatrixVP[0][0],unity_MatrixVP[1][0],unity_MatrixVP[2][0],unity_MatrixVP[3][0]) * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = float4(unity_MatrixVP[0][2],unity_MatrixVP[1][2],unity_MatrixVP[2][2],unity_MatrixVP[3][2]) * u_xlat1.zzzz + u_xlat0;
					    u_xlat0 = float4(unity_MatrixVP[0][3],unity_MatrixVP[1][3],unity_MatrixVP[2][3],unity_MatrixVP[3][3]) * u_xlat1.wwww + u_xlat0;
					    o.vertex = u_xlat0;
					    o.vs_TEXCOORD0.xy = i.in_TEXCOORD1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat1.x = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][0],unity_WorldToObject[1][0],unity_WorldToObject[2][0],unity_WorldToObject[3][0]).xyz);
					    u_xlat1.y = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][1],unity_WorldToObject[1][1],unity_WorldToObject[2][1],unity_WorldToObject[3][1]).xyz);
					    u_xlat1.z = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][2],unity_WorldToObject[1][2],unity_WorldToObject[2][2],unity_WorldToObject[3][2]).xyz);
					    u_xlat7 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat7 = rsqrt(u_xlat7);
					    o.vs_TEXCOORD1.xyz = u_xlat7 * u_xlat1.xyz;
					    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
					    u_xlat1.xzw = u_xlat0.xwy * float3(0.5, 0.5, 0.5);
					    o.vs_TEXCOORD3.zw = u_xlat0.zw;
					    o.vs_TEXCOORD3.xy = u_xlat1.zz + u_xlat1.xw;
					    o.vs_COLOR0 = i.in_COLOR0;
					    o.vs_TEXCOORD4 = float4(0.0, 0.0, 0.0, 0.0);
					    o.vs_TEXCOORD5 = float4(0.0, 0.0, 0.0, 0.0);
					    return o;
					}

#endif

#if 1 && defined (DIRECTIONAL) && defined (LIGHTPROBE_SH) && !defined (FADE_FROM_VERTEX_COLORS) && !defined (TRIPLANAR) && !defined (SHADOWS_SCREEN) && !defined (INSTANCING_ON)

					uniform float4 unused_0_0[12];
					uniform float4 _MainTex_ST;
					uniform float4 _Cloud1Tex_ST;
					uniform float4 _Cloud2Tex_ST;
					struct app_in {
						    float4 in_POSITION0 : POSITION;
						    float3 in_NORMAL0 : NORMAL;
						    float4 in_TEXCOORD1 : TEXCOORD1;
						    float4 in_COLOR0 : COLOR0;
					};
					struct inter {
						float4 vertex : SV_POSITION;
						float4 vs_TEXCOORD0 : TEXCOORD0;
						float2 vs_TEXCOORD1 : TEXCOORD1;
						float3 vs_TEXCOORD2 : TEXCOORD2;
						float3 vs_TEXCOORD3 : TEXCOORD3;
						float4 vs_TEXCOORD4 : TEXCOORD4;
						float4 vs_COLOR0 : COLOR0;
						float4 vs_TEXCOORD5 : TEXCOORD5;
						float4 vs_TEXCOORD6 : TEXCOORD6;
					};
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					inter vert(app_in i)
					{
					    inter o;
					float4 u_xlat0;
					float4 u_xlat1;
					float u_xlat7;
					    u_xlat0 = i.in_POSITION0.yyyy * float4(unity_ObjectToWorld[0][1],unity_ObjectToWorld[1][1],unity_ObjectToWorld[2][1],unity_ObjectToWorld[3][1]);
					    u_xlat0 = float4(unity_ObjectToWorld[0][0],unity_ObjectToWorld[1][0],unity_ObjectToWorld[2][0],unity_ObjectToWorld[3][0]) * i.in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = float4(unity_ObjectToWorld[0][2],unity_ObjectToWorld[1][2],unity_ObjectToWorld[2][2],unity_ObjectToWorld[3][2]) * i.in_POSITION0.zzzz + u_xlat0;
					    u_xlat1 = u_xlat0 + float4(unity_ObjectToWorld[0][3],unity_ObjectToWorld[1][3],unity_ObjectToWorld[2][3],unity_ObjectToWorld[3][3]);
					    o.vs_TEXCOORD3.xyz = float4(unity_ObjectToWorld[0][3],unity_ObjectToWorld[1][3],unity_ObjectToWorld[2][3],unity_ObjectToWorld[3][3]).xyz * i.in_POSITION0.www + u_xlat0.xyz;
					    u_xlat0 = u_xlat1.yyyy * float4(unity_MatrixVP[0][1],unity_MatrixVP[1][1],unity_MatrixVP[2][1],unity_MatrixVP[3][1]);
					    u_xlat0 = float4(unity_MatrixVP[0][0],unity_MatrixVP[1][0],unity_MatrixVP[2][0],unity_MatrixVP[3][0]) * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = float4(unity_MatrixVP[0][2],unity_MatrixVP[1][2],unity_MatrixVP[2][2],unity_MatrixVP[3][2]) * u_xlat1.zzzz + u_xlat0;
					    u_xlat0 = float4(unity_MatrixVP[0][3],unity_MatrixVP[1][3],unity_MatrixVP[2][3],unity_MatrixVP[3][3]) * u_xlat1.wwww + u_xlat0;
					    o.vertex = u_xlat0;
					    o.vs_TEXCOORD0.xy = i.in_TEXCOORD1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    o.vs_TEXCOORD0.zw = i.in_TEXCOORD1.xy * _Cloud1Tex_ST.xy + _Cloud1Tex_ST.zw;
					    o.vs_TEXCOORD1.xy = i.in_TEXCOORD1.xy * _Cloud2Tex_ST.xy + _Cloud2Tex_ST.zw;
					    u_xlat1.x = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][0],unity_WorldToObject[1][0],unity_WorldToObject[2][0],unity_WorldToObject[3][0]).xyz);
					    u_xlat1.y = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][1],unity_WorldToObject[1][1],unity_WorldToObject[2][1],unity_WorldToObject[3][1]).xyz);
					    u_xlat1.z = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][2],unity_WorldToObject[1][2],unity_WorldToObject[2][2],unity_WorldToObject[3][2]).xyz);
					    u_xlat7 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat7 = rsqrt(u_xlat7);
					    o.vs_TEXCOORD2.xyz = u_xlat7 * u_xlat1.xyz;
					    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
					    u_xlat1.xzw = u_xlat0.xwy * float3(0.5, 0.5, 0.5);
					    o.vs_TEXCOORD4.zw = u_xlat0.zw;
					    o.vs_TEXCOORD4.xy = u_xlat1.zz + u_xlat1.xw;
					    o.vs_COLOR0 = i.in_COLOR0;
					    o.vs_TEXCOORD5 = float4(0.0, 0.0, 0.0, 0.0);
					    o.vs_TEXCOORD6 = float4(0.0, 0.0, 0.0, 0.0);
					    return o;
					}

#endif

#if 1 && defined (DIRECTIONAL) && !defined (LIGHTPROBE_SH) && defined (FADE_FROM_VERTEX_COLORS) && !defined (TRIPLANAR) && defined (SHADOWS_SCREEN) && !defined (INSTANCING_ON)

					uniform float4 unused_0_0[13];
					uniform float4 _MainTex_ST;
					uniform float4 _Cloud1Tex_ST;
					uniform float4 _Cloud2Tex_ST;
					struct app_in {
						    float4 in_POSITION0 : POSITION;
						    float3 in_NORMAL0 : NORMAL;
						    float4 in_TEXCOORD1 : TEXCOORD1;
						    float4 in_COLOR0 : COLOR0;
					};
					struct inter {
						float4 vertex : SV_POSITION;
						float4 vs_TEXCOORD0 : TEXCOORD0;
						float2 vs_TEXCOORD1 : TEXCOORD1;
						float3 vs_TEXCOORD2 : TEXCOORD2;
						float3 vs_TEXCOORD3 : TEXCOORD3;
						float4 vs_TEXCOORD4 : TEXCOORD4;
						float4 vs_COLOR0 : COLOR0;
						float4 vs_TEXCOORD5 : TEXCOORD5;
						float4 vs_TEXCOORD6 : TEXCOORD6;
					};
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					inter vert(app_in i)
					{
					    inter o;
					float4 u_xlat0;
					float4 u_xlat1;
					float u_xlat7;
					    u_xlat0 = i.in_POSITION0.yyyy * float4(unity_ObjectToWorld[0][1],unity_ObjectToWorld[1][1],unity_ObjectToWorld[2][1],unity_ObjectToWorld[3][1]);
					    u_xlat0 = float4(unity_ObjectToWorld[0][0],unity_ObjectToWorld[1][0],unity_ObjectToWorld[2][0],unity_ObjectToWorld[3][0]) * i.in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = float4(unity_ObjectToWorld[0][2],unity_ObjectToWorld[1][2],unity_ObjectToWorld[2][2],unity_ObjectToWorld[3][2]) * i.in_POSITION0.zzzz + u_xlat0;
					    u_xlat1 = u_xlat0 + float4(unity_ObjectToWorld[0][3],unity_ObjectToWorld[1][3],unity_ObjectToWorld[2][3],unity_ObjectToWorld[3][3]);
					    o.vs_TEXCOORD3.xyz = float4(unity_ObjectToWorld[0][3],unity_ObjectToWorld[1][3],unity_ObjectToWorld[2][3],unity_ObjectToWorld[3][3]).xyz * i.in_POSITION0.www + u_xlat0.xyz;
					    u_xlat0 = u_xlat1.yyyy * float4(unity_MatrixVP[0][1],unity_MatrixVP[1][1],unity_MatrixVP[2][1],unity_MatrixVP[3][1]);
					    u_xlat0 = float4(unity_MatrixVP[0][0],unity_MatrixVP[1][0],unity_MatrixVP[2][0],unity_MatrixVP[3][0]) * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = float4(unity_MatrixVP[0][2],unity_MatrixVP[1][2],unity_MatrixVP[2][2],unity_MatrixVP[3][2]) * u_xlat1.zzzz + u_xlat0;
					    u_xlat0 = float4(unity_MatrixVP[0][3],unity_MatrixVP[1][3],unity_MatrixVP[2][3],unity_MatrixVP[3][3]) * u_xlat1.wwww + u_xlat0;
					    o.vertex = u_xlat0;
					    o.vs_TEXCOORD0.xy = i.in_TEXCOORD1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    o.vs_TEXCOORD0.zw = i.in_TEXCOORD1.xy * _Cloud1Tex_ST.xy + _Cloud1Tex_ST.zw;
					    o.vs_TEXCOORD1.xy = i.in_TEXCOORD1.xy * _Cloud2Tex_ST.xy + _Cloud2Tex_ST.zw;
					    u_xlat1.x = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][0],unity_WorldToObject[1][0],unity_WorldToObject[2][0],unity_WorldToObject[3][0]).xyz);
					    u_xlat1.y = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][1],unity_WorldToObject[1][1],unity_WorldToObject[2][1],unity_WorldToObject[3][1]).xyz);
					    u_xlat1.z = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][2],unity_WorldToObject[1][2],unity_WorldToObject[2][2],unity_WorldToObject[3][2]).xyz);
					    u_xlat7 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat7 = rsqrt(u_xlat7);
					    o.vs_TEXCOORD2.xyz = u_xlat7 * u_xlat1.xyz;
					    u_xlat1.x = u_xlat0.y * _ProjectionParams.x;
					    u_xlat1.w = u_xlat1.x * 0.5;
					    u_xlat1.xz = u_xlat0.xw * float2(0.5, 0.5);
					    u_xlat0.xy = u_xlat1.zz + u_xlat1.xw;
					    o.vs_TEXCOORD4 = u_xlat0;
					    o.vs_TEXCOORD5 = u_xlat0;
					    o.vs_COLOR0 = i.in_COLOR0;
					    o.vs_TEXCOORD6 = float4(0.0, 0.0, 0.0, 0.0);
					    return o;
					}

#endif

#if 1 && defined (DIRECTIONAL) && !defined (LIGHTPROBE_SH) && !defined (FADE_FROM_VERTEX_COLORS) && defined (TRIPLANAR) && defined (SHADOWS_SCREEN) && !defined (INSTANCING_ON)

					uniform float4 unused_0_0[15];
					uniform float4 _MainTex_ST;
					struct app_in {
						    float4 in_POSITION0 : POSITION;
						    float3 in_NORMAL0 : NORMAL;
						    float4 in_TEXCOORD1 : TEXCOORD1;
						    float4 in_COLOR0 : COLOR0;
					};
					struct inter {
						float4 vertex : SV_POSITION;
						float2 vs_TEXCOORD0 : TEXCOORD0;
						float3 vs_TEXCOORD1 : TEXCOORD1;
						float3 vs_TEXCOORD2 : TEXCOORD2;
						float4 vs_TEXCOORD3 : TEXCOORD3;
						float4 vs_COLOR0 : COLOR0;
						float4 vs_TEXCOORD4 : TEXCOORD4;
						float4 vs_TEXCOORD5 : TEXCOORD5;
					};
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					inter vert(app_in i)
					{
					    inter o;
					float4 u_xlat0;
					float4 u_xlat1;
					float u_xlat7;
					    u_xlat0 = i.in_POSITION0.yyyy * float4(unity_ObjectToWorld[0][1],unity_ObjectToWorld[1][1],unity_ObjectToWorld[2][1],unity_ObjectToWorld[3][1]);
					    u_xlat0 = float4(unity_ObjectToWorld[0][0],unity_ObjectToWorld[1][0],unity_ObjectToWorld[2][0],unity_ObjectToWorld[3][0]) * i.in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = float4(unity_ObjectToWorld[0][2],unity_ObjectToWorld[1][2],unity_ObjectToWorld[2][2],unity_ObjectToWorld[3][2]) * i.in_POSITION0.zzzz + u_xlat0;
					    u_xlat1 = u_xlat0 + float4(unity_ObjectToWorld[0][3],unity_ObjectToWorld[1][3],unity_ObjectToWorld[2][3],unity_ObjectToWorld[3][3]);
					    o.vs_TEXCOORD2.xyz = float4(unity_ObjectToWorld[0][3],unity_ObjectToWorld[1][3],unity_ObjectToWorld[2][3],unity_ObjectToWorld[3][3]).xyz * i.in_POSITION0.www + u_xlat0.xyz;
					    u_xlat0 = u_xlat1.yyyy * float4(unity_MatrixVP[0][1],unity_MatrixVP[1][1],unity_MatrixVP[2][1],unity_MatrixVP[3][1]);
					    u_xlat0 = float4(unity_MatrixVP[0][0],unity_MatrixVP[1][0],unity_MatrixVP[2][0],unity_MatrixVP[3][0]) * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = float4(unity_MatrixVP[0][2],unity_MatrixVP[1][2],unity_MatrixVP[2][2],unity_MatrixVP[3][2]) * u_xlat1.zzzz + u_xlat0;
					    u_xlat0 = float4(unity_MatrixVP[0][3],unity_MatrixVP[1][3],unity_MatrixVP[2][3],unity_MatrixVP[3][3]) * u_xlat1.wwww + u_xlat0;
					    o.vertex = u_xlat0;
					    o.vs_TEXCOORD0.xy = i.in_TEXCOORD1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat1.x = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][0],unity_WorldToObject[1][0],unity_WorldToObject[2][0],unity_WorldToObject[3][0]).xyz);
					    u_xlat1.y = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][1],unity_WorldToObject[1][1],unity_WorldToObject[2][1],unity_WorldToObject[3][1]).xyz);
					    u_xlat1.z = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][2],unity_WorldToObject[1][2],unity_WorldToObject[2][2],unity_WorldToObject[3][2]).xyz);
					    u_xlat7 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat7 = rsqrt(u_xlat7);
					    o.vs_TEXCOORD1.xyz = u_xlat7 * u_xlat1.xyz;
					    u_xlat1.x = u_xlat0.y * _ProjectionParams.x;
					    u_xlat1.w = u_xlat1.x * 0.5;
					    u_xlat1.xz = u_xlat0.xw * float2(0.5, 0.5);
					    u_xlat0.xy = u_xlat1.zz + u_xlat1.xw;
					    o.vs_TEXCOORD3 = u_xlat0;
					    o.vs_TEXCOORD4 = u_xlat0;
					    o.vs_COLOR0 = i.in_COLOR0;
					    o.vs_TEXCOORD5 = float4(0.0, 0.0, 0.0, 0.0);
					    return o;
					}

#endif

#if 1 && defined (DIRECTIONAL) && !defined (LIGHTPROBE_SH) && !defined (FADE_FROM_VERTEX_COLORS) && !defined (TRIPLANAR) && defined (SHADOWS_SCREEN) && !defined (INSTANCING_ON)

					uniform float4 unused_0_0[13];
					uniform float4 _MainTex_ST;
					uniform float4 _Cloud1Tex_ST;
					uniform float4 _Cloud2Tex_ST;
					struct app_in {
						    float4 in_POSITION0 : POSITION;
						    float3 in_NORMAL0 : NORMAL;
						    float4 in_TEXCOORD1 : TEXCOORD1;
						    float4 in_COLOR0 : COLOR0;
					};
					struct inter {
						float4 vertex : SV_POSITION;
						float4 vs_TEXCOORD0 : TEXCOORD0;
						float2 vs_TEXCOORD1 : TEXCOORD1;
						float3 vs_TEXCOORD2 : TEXCOORD2;
						float3 vs_TEXCOORD3 : TEXCOORD3;
						float4 vs_TEXCOORD4 : TEXCOORD4;
						float4 vs_COLOR0 : COLOR0;
						float4 vs_TEXCOORD5 : TEXCOORD5;
						float4 vs_TEXCOORD6 : TEXCOORD6;
					};
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					inter vert(app_in i)
					{
					    inter o;
					float4 u_xlat0;
					float4 u_xlat1;
					float u_xlat7;
					    u_xlat0 = i.in_POSITION0.yyyy * float4(unity_ObjectToWorld[0][1],unity_ObjectToWorld[1][1],unity_ObjectToWorld[2][1],unity_ObjectToWorld[3][1]);
					    u_xlat0 = float4(unity_ObjectToWorld[0][0],unity_ObjectToWorld[1][0],unity_ObjectToWorld[2][0],unity_ObjectToWorld[3][0]) * i.in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = float4(unity_ObjectToWorld[0][2],unity_ObjectToWorld[1][2],unity_ObjectToWorld[2][2],unity_ObjectToWorld[3][2]) * i.in_POSITION0.zzzz + u_xlat0;
					    u_xlat1 = u_xlat0 + float4(unity_ObjectToWorld[0][3],unity_ObjectToWorld[1][3],unity_ObjectToWorld[2][3],unity_ObjectToWorld[3][3]);
					    o.vs_TEXCOORD3.xyz = float4(unity_ObjectToWorld[0][3],unity_ObjectToWorld[1][3],unity_ObjectToWorld[2][3],unity_ObjectToWorld[3][3]).xyz * i.in_POSITION0.www + u_xlat0.xyz;
					    u_xlat0 = u_xlat1.yyyy * float4(unity_MatrixVP[0][1],unity_MatrixVP[1][1],unity_MatrixVP[2][1],unity_MatrixVP[3][1]);
					    u_xlat0 = float4(unity_MatrixVP[0][0],unity_MatrixVP[1][0],unity_MatrixVP[2][0],unity_MatrixVP[3][0]) * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = float4(unity_MatrixVP[0][2],unity_MatrixVP[1][2],unity_MatrixVP[2][2],unity_MatrixVP[3][2]) * u_xlat1.zzzz + u_xlat0;
					    u_xlat0 = float4(unity_MatrixVP[0][3],unity_MatrixVP[1][3],unity_MatrixVP[2][3],unity_MatrixVP[3][3]) * u_xlat1.wwww + u_xlat0;
					    o.vertex = u_xlat0;
					    o.vs_TEXCOORD0.xy = i.in_TEXCOORD1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    o.vs_TEXCOORD0.zw = i.in_TEXCOORD1.xy * _Cloud1Tex_ST.xy + _Cloud1Tex_ST.zw;
					    o.vs_TEXCOORD1.xy = i.in_TEXCOORD1.xy * _Cloud2Tex_ST.xy + _Cloud2Tex_ST.zw;
					    u_xlat1.x = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][0],unity_WorldToObject[1][0],unity_WorldToObject[2][0],unity_WorldToObject[3][0]).xyz);
					    u_xlat1.y = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][1],unity_WorldToObject[1][1],unity_WorldToObject[2][1],unity_WorldToObject[3][1]).xyz);
					    u_xlat1.z = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][2],unity_WorldToObject[1][2],unity_WorldToObject[2][2],unity_WorldToObject[3][2]).xyz);
					    u_xlat7 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat7 = rsqrt(u_xlat7);
					    o.vs_TEXCOORD2.xyz = u_xlat7 * u_xlat1.xyz;
					    u_xlat1.x = u_xlat0.y * _ProjectionParams.x;
					    u_xlat1.w = u_xlat1.x * 0.5;
					    u_xlat1.xz = u_xlat0.xw * float2(0.5, 0.5);
					    u_xlat0.xy = u_xlat1.zz + u_xlat1.xw;
					    o.vs_TEXCOORD4 = u_xlat0;
					    o.vs_TEXCOORD5 = u_xlat0;
					    o.vs_COLOR0 = i.in_COLOR0;
					    o.vs_TEXCOORD6 = float4(0.0, 0.0, 0.0, 0.0);
					    return o;
					}

#endif

#if 1 && defined (DIRECTIONAL) && defined (LIGHTPROBE_SH) && defined (FADE_FROM_VERTEX_COLORS) && !defined (TRIPLANAR) && defined (SHADOWS_SCREEN) && !defined (INSTANCING_ON)

					uniform float4 unused_0_0[13];
					uniform float4 _MainTex_ST;
					uniform float4 _Cloud1Tex_ST;
					uniform float4 _Cloud2Tex_ST;
					struct app_in {
						    float4 in_POSITION0 : POSITION;
						    float3 in_NORMAL0 : NORMAL;
						    float4 in_TEXCOORD1 : TEXCOORD1;
						    float4 in_COLOR0 : COLOR0;
					};
					struct inter {
						float4 vertex : SV_POSITION;
						float4 vs_TEXCOORD0 : TEXCOORD0;
						float2 vs_TEXCOORD1 : TEXCOORD1;
						float3 vs_TEXCOORD2 : TEXCOORD2;
						float3 vs_TEXCOORD3 : TEXCOORD3;
						float4 vs_TEXCOORD4 : TEXCOORD4;
						float4 vs_COLOR0 : COLOR0;
						float4 vs_TEXCOORD5 : TEXCOORD5;
						float4 vs_TEXCOORD6 : TEXCOORD6;
					};
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					inter vert(app_in i)
					{
					    inter o;
					float4 u_xlat0;
					float4 u_xlat1;
					float u_xlat7;
					    u_xlat0 = i.in_POSITION0.yyyy * float4(unity_ObjectToWorld[0][1],unity_ObjectToWorld[1][1],unity_ObjectToWorld[2][1],unity_ObjectToWorld[3][1]);
					    u_xlat0 = float4(unity_ObjectToWorld[0][0],unity_ObjectToWorld[1][0],unity_ObjectToWorld[2][0],unity_ObjectToWorld[3][0]) * i.in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = float4(unity_ObjectToWorld[0][2],unity_ObjectToWorld[1][2],unity_ObjectToWorld[2][2],unity_ObjectToWorld[3][2]) * i.in_POSITION0.zzzz + u_xlat0;
					    u_xlat1 = u_xlat0 + float4(unity_ObjectToWorld[0][3],unity_ObjectToWorld[1][3],unity_ObjectToWorld[2][3],unity_ObjectToWorld[3][3]);
					    o.vs_TEXCOORD3.xyz = float4(unity_ObjectToWorld[0][3],unity_ObjectToWorld[1][3],unity_ObjectToWorld[2][3],unity_ObjectToWorld[3][3]).xyz * i.in_POSITION0.www + u_xlat0.xyz;
					    u_xlat0 = u_xlat1.yyyy * float4(unity_MatrixVP[0][1],unity_MatrixVP[1][1],unity_MatrixVP[2][1],unity_MatrixVP[3][1]);
					    u_xlat0 = float4(unity_MatrixVP[0][0],unity_MatrixVP[1][0],unity_MatrixVP[2][0],unity_MatrixVP[3][0]) * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = float4(unity_MatrixVP[0][2],unity_MatrixVP[1][2],unity_MatrixVP[2][2],unity_MatrixVP[3][2]) * u_xlat1.zzzz + u_xlat0;
					    u_xlat0 = float4(unity_MatrixVP[0][3],unity_MatrixVP[1][3],unity_MatrixVP[2][3],unity_MatrixVP[3][3]) * u_xlat1.wwww + u_xlat0;
					    o.vertex = u_xlat0;
					    o.vs_TEXCOORD0.xy = i.in_TEXCOORD1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    o.vs_TEXCOORD0.zw = i.in_TEXCOORD1.xy * _Cloud1Tex_ST.xy + _Cloud1Tex_ST.zw;
					    o.vs_TEXCOORD1.xy = i.in_TEXCOORD1.xy * _Cloud2Tex_ST.xy + _Cloud2Tex_ST.zw;
					    u_xlat1.x = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][0],unity_WorldToObject[1][0],unity_WorldToObject[2][0],unity_WorldToObject[3][0]).xyz);
					    u_xlat1.y = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][1],unity_WorldToObject[1][1],unity_WorldToObject[2][1],unity_WorldToObject[3][1]).xyz);
					    u_xlat1.z = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][2],unity_WorldToObject[1][2],unity_WorldToObject[2][2],unity_WorldToObject[3][2]).xyz);
					    u_xlat7 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat7 = rsqrt(u_xlat7);
					    o.vs_TEXCOORD2.xyz = u_xlat7 * u_xlat1.xyz;
					    u_xlat1.x = u_xlat0.y * _ProjectionParams.x;
					    u_xlat1.w = u_xlat1.x * 0.5;
					    u_xlat1.xz = u_xlat0.xw * float2(0.5, 0.5);
					    u_xlat0.xy = u_xlat1.zz + u_xlat1.xw;
					    o.vs_TEXCOORD4 = u_xlat0;
					    o.vs_TEXCOORD5 = u_xlat0;
					    o.vs_COLOR0 = i.in_COLOR0;
					    o.vs_TEXCOORD6 = float4(0.0, 0.0, 0.0, 0.0);
					    return o;
					}

#endif

#if 1 && defined (DIRECTIONAL) && defined (LIGHTPROBE_SH) && !defined (FADE_FROM_VERTEX_COLORS) && defined (TRIPLANAR) && defined (SHADOWS_SCREEN) && !defined (INSTANCING_ON)

					uniform float4 unused_0_0[15];
					uniform float4 _MainTex_ST;
					struct app_in {
						    float4 in_POSITION0 : POSITION;
						    float3 in_NORMAL0 : NORMAL;
						    float4 in_TEXCOORD1 : TEXCOORD1;
						    float4 in_COLOR0 : COLOR0;
					};
					struct inter {
						float4 vertex : SV_POSITION;
						float2 vs_TEXCOORD0 : TEXCOORD0;
						float3 vs_TEXCOORD1 : TEXCOORD1;
						float3 vs_TEXCOORD2 : TEXCOORD2;
						float4 vs_TEXCOORD3 : TEXCOORD3;
						float4 vs_COLOR0 : COLOR0;
						float4 vs_TEXCOORD4 : TEXCOORD4;
						float4 vs_TEXCOORD5 : TEXCOORD5;
					};
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					inter vert(app_in i)
					{
					    inter o;
					float4 u_xlat0;
					float4 u_xlat1;
					float u_xlat7;
					    u_xlat0 = i.in_POSITION0.yyyy * float4(unity_ObjectToWorld[0][1],unity_ObjectToWorld[1][1],unity_ObjectToWorld[2][1],unity_ObjectToWorld[3][1]);
					    u_xlat0 = float4(unity_ObjectToWorld[0][0],unity_ObjectToWorld[1][0],unity_ObjectToWorld[2][0],unity_ObjectToWorld[3][0]) * i.in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = float4(unity_ObjectToWorld[0][2],unity_ObjectToWorld[1][2],unity_ObjectToWorld[2][2],unity_ObjectToWorld[3][2]) * i.in_POSITION0.zzzz + u_xlat0;
					    u_xlat1 = u_xlat0 + float4(unity_ObjectToWorld[0][3],unity_ObjectToWorld[1][3],unity_ObjectToWorld[2][3],unity_ObjectToWorld[3][3]);
					    o.vs_TEXCOORD2.xyz = float4(unity_ObjectToWorld[0][3],unity_ObjectToWorld[1][3],unity_ObjectToWorld[2][3],unity_ObjectToWorld[3][3]).xyz * i.in_POSITION0.www + u_xlat0.xyz;
					    u_xlat0 = u_xlat1.yyyy * float4(unity_MatrixVP[0][1],unity_MatrixVP[1][1],unity_MatrixVP[2][1],unity_MatrixVP[3][1]);
					    u_xlat0 = float4(unity_MatrixVP[0][0],unity_MatrixVP[1][0],unity_MatrixVP[2][0],unity_MatrixVP[3][0]) * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = float4(unity_MatrixVP[0][2],unity_MatrixVP[1][2],unity_MatrixVP[2][2],unity_MatrixVP[3][2]) * u_xlat1.zzzz + u_xlat0;
					    u_xlat0 = float4(unity_MatrixVP[0][3],unity_MatrixVP[1][3],unity_MatrixVP[2][3],unity_MatrixVP[3][3]) * u_xlat1.wwww + u_xlat0;
					    o.vertex = u_xlat0;
					    o.vs_TEXCOORD0.xy = i.in_TEXCOORD1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat1.x = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][0],unity_WorldToObject[1][0],unity_WorldToObject[2][0],unity_WorldToObject[3][0]).xyz);
					    u_xlat1.y = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][1],unity_WorldToObject[1][1],unity_WorldToObject[2][1],unity_WorldToObject[3][1]).xyz);
					    u_xlat1.z = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][2],unity_WorldToObject[1][2],unity_WorldToObject[2][2],unity_WorldToObject[3][2]).xyz);
					    u_xlat7 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat7 = rsqrt(u_xlat7);
					    o.vs_TEXCOORD1.xyz = u_xlat7 * u_xlat1.xyz;
					    u_xlat1.x = u_xlat0.y * _ProjectionParams.x;
					    u_xlat1.w = u_xlat1.x * 0.5;
					    u_xlat1.xz = u_xlat0.xw * float2(0.5, 0.5);
					    u_xlat0.xy = u_xlat1.zz + u_xlat1.xw;
					    o.vs_TEXCOORD3 = u_xlat0;
					    o.vs_TEXCOORD4 = u_xlat0;
					    o.vs_COLOR0 = i.in_COLOR0;
					    o.vs_TEXCOORD5 = float4(0.0, 0.0, 0.0, 0.0);
					    return o;
					}

#endif

#if 1 && defined (DIRECTIONAL) && defined (LIGHTPROBE_SH) && !defined (FADE_FROM_VERTEX_COLORS) && !defined (TRIPLANAR) && defined (SHADOWS_SCREEN) && !defined (INSTANCING_ON)

					uniform float4 unused_0_0[13];
					uniform float4 _MainTex_ST;
					uniform float4 _Cloud1Tex_ST;
					uniform float4 _Cloud2Tex_ST;
					struct app_in {
						    float4 in_POSITION0 : POSITION;
						    float3 in_NORMAL0 : NORMAL;
						    float4 in_TEXCOORD1 : TEXCOORD1;
						    float4 in_COLOR0 : COLOR0;
					};
					struct inter {
						float4 vertex : SV_POSITION;
						float4 vs_TEXCOORD0 : TEXCOORD0;
						float2 vs_TEXCOORD1 : TEXCOORD1;
						float3 vs_TEXCOORD2 : TEXCOORD2;
						float3 vs_TEXCOORD3 : TEXCOORD3;
						float4 vs_TEXCOORD4 : TEXCOORD4;
						float4 vs_COLOR0 : COLOR0;
						float4 vs_TEXCOORD5 : TEXCOORD5;
						float4 vs_TEXCOORD6 : TEXCOORD6;
					};
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					inter vert(app_in i)
					{
					    inter o;
					float4 u_xlat0;
					float4 u_xlat1;
					float u_xlat7;
					    u_xlat0 = i.in_POSITION0.yyyy * float4(unity_ObjectToWorld[0][1],unity_ObjectToWorld[1][1],unity_ObjectToWorld[2][1],unity_ObjectToWorld[3][1]);
					    u_xlat0 = float4(unity_ObjectToWorld[0][0],unity_ObjectToWorld[1][0],unity_ObjectToWorld[2][0],unity_ObjectToWorld[3][0]) * i.in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = float4(unity_ObjectToWorld[0][2],unity_ObjectToWorld[1][2],unity_ObjectToWorld[2][2],unity_ObjectToWorld[3][2]) * i.in_POSITION0.zzzz + u_xlat0;
					    u_xlat1 = u_xlat0 + float4(unity_ObjectToWorld[0][3],unity_ObjectToWorld[1][3],unity_ObjectToWorld[2][3],unity_ObjectToWorld[3][3]);
					    o.vs_TEXCOORD3.xyz = float4(unity_ObjectToWorld[0][3],unity_ObjectToWorld[1][3],unity_ObjectToWorld[2][3],unity_ObjectToWorld[3][3]).xyz * i.in_POSITION0.www + u_xlat0.xyz;
					    u_xlat0 = u_xlat1.yyyy * float4(unity_MatrixVP[0][1],unity_MatrixVP[1][1],unity_MatrixVP[2][1],unity_MatrixVP[3][1]);
					    u_xlat0 = float4(unity_MatrixVP[0][0],unity_MatrixVP[1][0],unity_MatrixVP[2][0],unity_MatrixVP[3][0]) * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = float4(unity_MatrixVP[0][2],unity_MatrixVP[1][2],unity_MatrixVP[2][2],unity_MatrixVP[3][2]) * u_xlat1.zzzz + u_xlat0;
					    u_xlat0 = float4(unity_MatrixVP[0][3],unity_MatrixVP[1][3],unity_MatrixVP[2][3],unity_MatrixVP[3][3]) * u_xlat1.wwww + u_xlat0;
					    o.vertex = u_xlat0;
					    o.vs_TEXCOORD0.xy = i.in_TEXCOORD1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    o.vs_TEXCOORD0.zw = i.in_TEXCOORD1.xy * _Cloud1Tex_ST.xy + _Cloud1Tex_ST.zw;
					    o.vs_TEXCOORD1.xy = i.in_TEXCOORD1.xy * _Cloud2Tex_ST.xy + _Cloud2Tex_ST.zw;
					    u_xlat1.x = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][0],unity_WorldToObject[1][0],unity_WorldToObject[2][0],unity_WorldToObject[3][0]).xyz);
					    u_xlat1.y = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][1],unity_WorldToObject[1][1],unity_WorldToObject[2][1],unity_WorldToObject[3][1]).xyz);
					    u_xlat1.z = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][2],unity_WorldToObject[1][2],unity_WorldToObject[2][2],unity_WorldToObject[3][2]).xyz);
					    u_xlat7 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat7 = rsqrt(u_xlat7);
					    o.vs_TEXCOORD2.xyz = u_xlat7 * u_xlat1.xyz;
					    u_xlat1.x = u_xlat0.y * _ProjectionParams.x;
					    u_xlat1.w = u_xlat1.x * 0.5;
					    u_xlat1.xz = u_xlat0.xw * float2(0.5, 0.5);
					    u_xlat0.xy = u_xlat1.zz + u_xlat1.xw;
					    o.vs_TEXCOORD4 = u_xlat0;
					    o.vs_TEXCOORD5 = u_xlat0;
					    o.vs_COLOR0 = i.in_COLOR0;
					    o.vs_TEXCOORD6 = float4(0.0, 0.0, 0.0, 0.0);
					    return o;
					}

#endif

#if 1 && defined (DIRECTIONAL) && !defined (LIGHTPROBE_SH) && defined (FADE_FROM_VERTEX_COLORS) && !defined (TRIPLANAR) && !defined (SHADOWS_SCREEN) && !defined (INSTANCING_ON)

					uniform float4 unused_0_0[12];
					uniform float4 _MainTex_ST;
					uniform float4 _Cloud1Tex_ST;
					uniform float4 _Cloud2Tex_ST;
					struct app_in {
						    float4 in_POSITION0 : POSITION;
						    float3 in_NORMAL0 : NORMAL;
						    float4 in_TEXCOORD1 : TEXCOORD1;
						    float4 in_COLOR0 : COLOR0;
					};
					struct inter {
						float4 vertex : SV_POSITION;
						float4 vs_TEXCOORD0 : TEXCOORD0;
						float2 vs_TEXCOORD1 : TEXCOORD1;
						float3 vs_TEXCOORD2 : TEXCOORD2;
						float3 vs_TEXCOORD3 : TEXCOORD3;
						float4 vs_TEXCOORD4 : TEXCOORD4;
						float4 vs_COLOR0 : COLOR0;
						float4 vs_TEXCOORD5 : TEXCOORD5;
						float4 vs_TEXCOORD6 : TEXCOORD6;
					};
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					inter vert(app_in i)
					{
					    inter o;
					float4 u_xlat0;
					float4 u_xlat1;
					float u_xlat7;
					    u_xlat0 = i.in_POSITION0.yyyy * float4(unity_ObjectToWorld[0][1],unity_ObjectToWorld[1][1],unity_ObjectToWorld[2][1],unity_ObjectToWorld[3][1]);
					    u_xlat0 = float4(unity_ObjectToWorld[0][0],unity_ObjectToWorld[1][0],unity_ObjectToWorld[2][0],unity_ObjectToWorld[3][0]) * i.in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = float4(unity_ObjectToWorld[0][2],unity_ObjectToWorld[1][2],unity_ObjectToWorld[2][2],unity_ObjectToWorld[3][2]) * i.in_POSITION0.zzzz + u_xlat0;
					    u_xlat1 = u_xlat0 + float4(unity_ObjectToWorld[0][3],unity_ObjectToWorld[1][3],unity_ObjectToWorld[2][3],unity_ObjectToWorld[3][3]);
					    o.vs_TEXCOORD3.xyz = float4(unity_ObjectToWorld[0][3],unity_ObjectToWorld[1][3],unity_ObjectToWorld[2][3],unity_ObjectToWorld[3][3]).xyz * i.in_POSITION0.www + u_xlat0.xyz;
					    u_xlat0 = u_xlat1.yyyy * float4(unity_MatrixVP[0][1],unity_MatrixVP[1][1],unity_MatrixVP[2][1],unity_MatrixVP[3][1]);
					    u_xlat0 = float4(unity_MatrixVP[0][0],unity_MatrixVP[1][0],unity_MatrixVP[2][0],unity_MatrixVP[3][0]) * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = float4(unity_MatrixVP[0][2],unity_MatrixVP[1][2],unity_MatrixVP[2][2],unity_MatrixVP[3][2]) * u_xlat1.zzzz + u_xlat0;
					    u_xlat0 = float4(unity_MatrixVP[0][3],unity_MatrixVP[1][3],unity_MatrixVP[2][3],unity_MatrixVP[3][3]) * u_xlat1.wwww + u_xlat0;
					    o.vertex = u_xlat0;
					    o.vs_TEXCOORD0.xy = i.in_TEXCOORD1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    o.vs_TEXCOORD0.zw = i.in_TEXCOORD1.xy * _Cloud1Tex_ST.xy + _Cloud1Tex_ST.zw;
					    o.vs_TEXCOORD1.xy = i.in_TEXCOORD1.xy * _Cloud2Tex_ST.xy + _Cloud2Tex_ST.zw;
					    u_xlat1.x = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][0],unity_WorldToObject[1][0],unity_WorldToObject[2][0],unity_WorldToObject[3][0]).xyz);
					    u_xlat1.y = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][1],unity_WorldToObject[1][1],unity_WorldToObject[2][1],unity_WorldToObject[3][1]).xyz);
					    u_xlat1.z = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][2],unity_WorldToObject[1][2],unity_WorldToObject[2][2],unity_WorldToObject[3][2]).xyz);
					    u_xlat7 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat7 = rsqrt(u_xlat7);
					    o.vs_TEXCOORD2.xyz = u_xlat7 * u_xlat1.xyz;
					    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
					    u_xlat1.xzw = u_xlat0.xwy * float3(0.5, 0.5, 0.5);
					    o.vs_TEXCOORD4.zw = u_xlat0.zw;
					    o.vs_TEXCOORD4.xy = u_xlat1.zz + u_xlat1.xw;
					    o.vs_COLOR0 = i.in_COLOR0;
					    o.vs_TEXCOORD5 = float4(0.0, 0.0, 0.0, 0.0);
					    o.vs_TEXCOORD6 = float4(0.0, 0.0, 0.0, 0.0);
					    return o;
					}

#endif

#if 1 && defined (DIRECTIONAL) && !defined (LIGHTPROBE_SH) && !defined (FADE_FROM_VERTEX_COLORS) && defined (TRIPLANAR) && !defined (SHADOWS_SCREEN) && !defined (INSTANCING_ON)

					uniform float4 unused_0_0[14];
					uniform float4 _MainTex_ST;
					struct app_in {
						    float4 in_POSITION0 : POSITION;
						    float3 in_NORMAL0 : NORMAL;
						    float4 in_TEXCOORD1 : TEXCOORD1;
						    float4 in_COLOR0 : COLOR0;
					};
					struct inter {
						float4 vertex : SV_POSITION;
						float2 vs_TEXCOORD0 : TEXCOORD0;
						float3 vs_TEXCOORD1 : TEXCOORD1;
						float3 vs_TEXCOORD2 : TEXCOORD2;
						float4 vs_TEXCOORD3 : TEXCOORD3;
						float4 vs_COLOR0 : COLOR0;
						float4 vs_TEXCOORD4 : TEXCOORD4;
						float4 vs_TEXCOORD5 : TEXCOORD5;
					};
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					inter vert(app_in i)
					{
					    inter o;
					float4 u_xlat0;
					float4 u_xlat1;
					float u_xlat7;
					    u_xlat0 = i.in_POSITION0.yyyy * float4(unity_ObjectToWorld[0][1],unity_ObjectToWorld[1][1],unity_ObjectToWorld[2][1],unity_ObjectToWorld[3][1]);
					    u_xlat0 = float4(unity_ObjectToWorld[0][0],unity_ObjectToWorld[1][0],unity_ObjectToWorld[2][0],unity_ObjectToWorld[3][0]) * i.in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = float4(unity_ObjectToWorld[0][2],unity_ObjectToWorld[1][2],unity_ObjectToWorld[2][2],unity_ObjectToWorld[3][2]) * i.in_POSITION0.zzzz + u_xlat0;
					    u_xlat1 = u_xlat0 + float4(unity_ObjectToWorld[0][3],unity_ObjectToWorld[1][3],unity_ObjectToWorld[2][3],unity_ObjectToWorld[3][3]);
					    o.vs_TEXCOORD2.xyz = float4(unity_ObjectToWorld[0][3],unity_ObjectToWorld[1][3],unity_ObjectToWorld[2][3],unity_ObjectToWorld[3][3]).xyz * i.in_POSITION0.www + u_xlat0.xyz;
					    u_xlat0 = u_xlat1.yyyy * float4(unity_MatrixVP[0][1],unity_MatrixVP[1][1],unity_MatrixVP[2][1],unity_MatrixVP[3][1]);
					    u_xlat0 = float4(unity_MatrixVP[0][0],unity_MatrixVP[1][0],unity_MatrixVP[2][0],unity_MatrixVP[3][0]) * u_xlat1.xxxx + u_xlat0;
					    u_xlat0 = float4(unity_MatrixVP[0][2],unity_MatrixVP[1][2],unity_MatrixVP[2][2],unity_MatrixVP[3][2]) * u_xlat1.zzzz + u_xlat0;
					    u_xlat0 = float4(unity_MatrixVP[0][3],unity_MatrixVP[1][3],unity_MatrixVP[2][3],unity_MatrixVP[3][3]) * u_xlat1.wwww + u_xlat0;
					    o.vertex = u_xlat0;
					    o.vs_TEXCOORD0.xy = i.in_TEXCOORD1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat1.x = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][0],unity_WorldToObject[1][0],unity_WorldToObject[2][0],unity_WorldToObject[3][0]).xyz);
					    u_xlat1.y = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][1],unity_WorldToObject[1][1],unity_WorldToObject[2][1],unity_WorldToObject[3][1]).xyz);
					    u_xlat1.z = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][2],unity_WorldToObject[1][2],unity_WorldToObject[2][2],unity_WorldToObject[3][2]).xyz);
					    u_xlat7 = dot(u_xlat1.xyz, u_xlat1.xyz);
					    u_xlat7 = rsqrt(u_xlat7);
					    o.vs_TEXCOORD1.xyz = u_xlat7 * u_xlat1.xyz;
					    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
					    u_xlat1.xzw = u_xlat0.xwy * float3(0.5, 0.5, 0.5);
					    o.vs_TEXCOORD3.zw = u_xlat0.zw;
					    o.vs_TEXCOORD3.xy = u_xlat1.zz + u_xlat1.xw;
					    o.vs_COLOR0 = i.in_COLOR0;
					    o.vs_TEXCOORD4 = float4(0.0, 0.0, 0.0, 0.0);
					    o.vs_TEXCOORD5 = float4(0.0, 0.0, 0.0, 0.0);
					    return o;
					}

#endif

#if 1 && defined (DIRECTIONAL) && !defined (LIGHTPROBE_SH) && !defined (FADE_FROM_VERTEX_COLORS) && !defined (TRIPLANAR) && !defined (SHADOWS_SCREEN) && defined (INSTANCING_ON)

					uniform float4 unused_0_0[12];
					uniform float4 _MainTex_ST;
					uniform float4 _Cloud1Tex_ST;
					uniform float4 _Cloud2Tex_ST;
					struct app_in {
						    float4 in_POSITION0 : POSITION;
						    float3 in_NORMAL0 : NORMAL;
						    float4 in_TEXCOORD1 : TEXCOORD1;
						    float4 in_COLOR0 : COLOR0;
						    UNITY_VERTEX_INPUT_INSTANCE_ID
					};
					struct inter {
						float4 vertex : SV_POSITION;
						float4 vs_TEXCOORD0 : TEXCOORD0;
						float2 vs_TEXCOORD1 : TEXCOORD1;
						float3 vs_TEXCOORD2 : TEXCOORD2;
						float3 vs_TEXCOORD3 : TEXCOORD3;
						float4 vs_TEXCOORD4 : TEXCOORD4;
						float4 vs_COLOR0 : COLOR0;
						float4 vs_TEXCOORD5 : TEXCOORD5;
						float4 vs_TEXCOORD6 : TEXCOORD6;
					};
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					inter vert(app_in i)
					{
					    inter o;
UNITY_SETUP_INSTANCE_ID(i);
					float4 u_xlat0;
					int u_xlati0;
					float4 u_xlat1;
					float4 u_xlat2;
					    u_xlati0 = 0 + unity_BaseInstanceID;
					    u_xlati0 = u_xlati0 << 3;
					    u_xlat1 = i.in_POSITION0.yyyy * float4(unity_ObjectToWorld[0][1],unity_ObjectToWorld[1][1],unity_ObjectToWorld[2][1],unity_ObjectToWorld[3][1]);
					    u_xlat1 = float4(unity_ObjectToWorld[0][0],unity_ObjectToWorld[1][0],unity_ObjectToWorld[2][0],unity_ObjectToWorld[3][0]) * i.in_POSITION0.xxxx + u_xlat1;
					    u_xlat1 = float4(unity_ObjectToWorld[0][2],unity_ObjectToWorld[1][2],unity_ObjectToWorld[2][2],unity_ObjectToWorld[3][2]) * i.in_POSITION0.zzzz + u_xlat1;
					    u_xlat2 = u_xlat1 + float4(unity_ObjectToWorld[0][3],unity_ObjectToWorld[1][3],unity_ObjectToWorld[2][3],unity_ObjectToWorld[3][3]);
					    o.vs_TEXCOORD3.xyz = float4(unity_ObjectToWorld[0][3],unity_ObjectToWorld[1][3],unity_ObjectToWorld[2][3],unity_ObjectToWorld[3][3]).xyz * i.in_POSITION0.www + u_xlat1.xyz;
					    u_xlat1 = u_xlat2.yyyy * float4(unity_MatrixVP[0][1],unity_MatrixVP[1][1],unity_MatrixVP[2][1],unity_MatrixVP[3][1]);
					    u_xlat1 = float4(unity_MatrixVP[0][0],unity_MatrixVP[1][0],unity_MatrixVP[2][0],unity_MatrixVP[3][0]) * u_xlat2.xxxx + u_xlat1;
					    u_xlat1 = float4(unity_MatrixVP[0][2],unity_MatrixVP[1][2],unity_MatrixVP[2][2],unity_MatrixVP[3][2]) * u_xlat2.zzzz + u_xlat1;
					    u_xlat1 = float4(unity_MatrixVP[0][3],unity_MatrixVP[1][3],unity_MatrixVP[2][3],unity_MatrixVP[3][3]) * u_xlat2.wwww + u_xlat1;
					    o.vertex = u_xlat1;
					    o.vs_TEXCOORD0.xy = i.in_TEXCOORD1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    o.vs_TEXCOORD0.zw = i.in_TEXCOORD1.xy * _Cloud1Tex_ST.xy + _Cloud1Tex_ST.zw;
					    o.vs_TEXCOORD1.xy = i.in_TEXCOORD1.xy * _Cloud2Tex_ST.xy + _Cloud2Tex_ST.zw;
					    u_xlat2.x = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][0],unity_WorldToObject[1][0],unity_WorldToObject[2][0],unity_WorldToObject[3][0]).xyz);
					    u_xlat2.y = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][1],unity_WorldToObject[1][1],unity_WorldToObject[2][1],unity_WorldToObject[3][1]).xyz);
					    u_xlat2.z = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][2],unity_WorldToObject[1][2],unity_WorldToObject[2][2],unity_WorldToObject[3][2]).xyz);
					    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat0.x = rsqrt(u_xlat0.x);
					    o.vs_TEXCOORD2.xyz = u_xlat0.xxx * u_xlat2.xyz;
					    u_xlat0.x = u_xlat1.y * _ProjectionParams.x;
					    u_xlat0.w = u_xlat0.x * 0.5;
					    u_xlat0.xz = u_xlat1.xw * float2(0.5, 0.5);
					    o.vs_TEXCOORD4.zw = u_xlat1.zw;
					    o.vs_TEXCOORD4.xy = u_xlat0.zz + u_xlat0.xw;
					    o.vs_COLOR0 = i.in_COLOR0;
					    o.vs_TEXCOORD5 = float4(0.0, 0.0, 0.0, 0.0);
					    o.vs_TEXCOORD6 = float4(0.0, 0.0, 0.0, 0.0);
					    return o;
					}

#endif

#if 1 && defined (DIRECTIONAL) && defined (LIGHTPROBE_SH) && defined (FADE_FROM_VERTEX_COLORS) && !defined (TRIPLANAR) && !defined (SHADOWS_SCREEN) && defined (INSTANCING_ON)

					uniform float4 unused_0_0[12];
					uniform float4 _MainTex_ST;
					uniform float4 _Cloud1Tex_ST;
					uniform float4 _Cloud2Tex_ST;
					struct app_in {
						    float4 in_POSITION0 : POSITION;
						    float3 in_NORMAL0 : NORMAL;
						    float4 in_TEXCOORD1 : TEXCOORD1;
						    float4 in_COLOR0 : COLOR0;
						    UNITY_VERTEX_INPUT_INSTANCE_ID
					};
					struct inter {
						float4 vertex : SV_POSITION;
						float4 vs_TEXCOORD0 : TEXCOORD0;
						float2 vs_TEXCOORD1 : TEXCOORD1;
						float3 vs_TEXCOORD2 : TEXCOORD2;
						float3 vs_TEXCOORD3 : TEXCOORD3;
						float4 vs_TEXCOORD4 : TEXCOORD4;
						float4 vs_COLOR0 : COLOR0;
						float4 vs_TEXCOORD5 : TEXCOORD5;
						float4 vs_TEXCOORD6 : TEXCOORD6;
					};
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					inter vert(app_in i)
					{
					    inter o;
UNITY_SETUP_INSTANCE_ID(i);
					float4 u_xlat0;
					int u_xlati0;
					float4 u_xlat1;
					float4 u_xlat2;
					    u_xlati0 = 0 + unity_BaseInstanceID;
					    u_xlati0 = u_xlati0 << 3;
					    u_xlat1 = i.in_POSITION0.yyyy * float4(unity_ObjectToWorld[0][1],unity_ObjectToWorld[1][1],unity_ObjectToWorld[2][1],unity_ObjectToWorld[3][1]);
					    u_xlat1 = float4(unity_ObjectToWorld[0][0],unity_ObjectToWorld[1][0],unity_ObjectToWorld[2][0],unity_ObjectToWorld[3][0]) * i.in_POSITION0.xxxx + u_xlat1;
					    u_xlat1 = float4(unity_ObjectToWorld[0][2],unity_ObjectToWorld[1][2],unity_ObjectToWorld[2][2],unity_ObjectToWorld[3][2]) * i.in_POSITION0.zzzz + u_xlat1;
					    u_xlat2 = u_xlat1 + float4(unity_ObjectToWorld[0][3],unity_ObjectToWorld[1][3],unity_ObjectToWorld[2][3],unity_ObjectToWorld[3][3]);
					    o.vs_TEXCOORD3.xyz = float4(unity_ObjectToWorld[0][3],unity_ObjectToWorld[1][3],unity_ObjectToWorld[2][3],unity_ObjectToWorld[3][3]).xyz * i.in_POSITION0.www + u_xlat1.xyz;
					    u_xlat1 = u_xlat2.yyyy * float4(unity_MatrixVP[0][1],unity_MatrixVP[1][1],unity_MatrixVP[2][1],unity_MatrixVP[3][1]);
					    u_xlat1 = float4(unity_MatrixVP[0][0],unity_MatrixVP[1][0],unity_MatrixVP[2][0],unity_MatrixVP[3][0]) * u_xlat2.xxxx + u_xlat1;
					    u_xlat1 = float4(unity_MatrixVP[0][2],unity_MatrixVP[1][2],unity_MatrixVP[2][2],unity_MatrixVP[3][2]) * u_xlat2.zzzz + u_xlat1;
					    u_xlat1 = float4(unity_MatrixVP[0][3],unity_MatrixVP[1][3],unity_MatrixVP[2][3],unity_MatrixVP[3][3]) * u_xlat2.wwww + u_xlat1;
					    o.vertex = u_xlat1;
					    o.vs_TEXCOORD0.xy = i.in_TEXCOORD1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    o.vs_TEXCOORD0.zw = i.in_TEXCOORD1.xy * _Cloud1Tex_ST.xy + _Cloud1Tex_ST.zw;
					    o.vs_TEXCOORD1.xy = i.in_TEXCOORD1.xy * _Cloud2Tex_ST.xy + _Cloud2Tex_ST.zw;
					    u_xlat2.x = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][0],unity_WorldToObject[1][0],unity_WorldToObject[2][0],unity_WorldToObject[3][0]).xyz);
					    u_xlat2.y = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][1],unity_WorldToObject[1][1],unity_WorldToObject[2][1],unity_WorldToObject[3][1]).xyz);
					    u_xlat2.z = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][2],unity_WorldToObject[1][2],unity_WorldToObject[2][2],unity_WorldToObject[3][2]).xyz);
					    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat0.x = rsqrt(u_xlat0.x);
					    o.vs_TEXCOORD2.xyz = u_xlat0.xxx * u_xlat2.xyz;
					    u_xlat0.x = u_xlat1.y * _ProjectionParams.x;
					    u_xlat0.w = u_xlat0.x * 0.5;
					    u_xlat0.xz = u_xlat1.xw * float2(0.5, 0.5);
					    o.vs_TEXCOORD4.zw = u_xlat1.zw;
					    o.vs_TEXCOORD4.xy = u_xlat0.zz + u_xlat0.xw;
					    o.vs_COLOR0 = i.in_COLOR0;
					    o.vs_TEXCOORD5 = float4(0.0, 0.0, 0.0, 0.0);
					    o.vs_TEXCOORD6 = float4(0.0, 0.0, 0.0, 0.0);
					    return o;
					}

#endif

#if 1 && defined (DIRECTIONAL) && defined (LIGHTPROBE_SH) && !defined (FADE_FROM_VERTEX_COLORS) && defined (TRIPLANAR) && !defined (SHADOWS_SCREEN) && defined (INSTANCING_ON)

					uniform float4 unused_0_0[14];
					uniform float4 _MainTex_ST;
					struct app_in {
						    float4 in_POSITION0 : POSITION;
						    float3 in_NORMAL0 : NORMAL;
						    float4 in_TEXCOORD1 : TEXCOORD1;
						    float4 in_COLOR0 : COLOR0;
						    UNITY_VERTEX_INPUT_INSTANCE_ID
					};
					struct inter {
						float4 vertex : SV_POSITION;
						float2 vs_TEXCOORD0 : TEXCOORD0;
						float3 vs_TEXCOORD1 : TEXCOORD1;
						float3 vs_TEXCOORD2 : TEXCOORD2;
						float4 vs_TEXCOORD3 : TEXCOORD3;
						float4 vs_COLOR0 : COLOR0;
						float4 vs_TEXCOORD4 : TEXCOORD4;
						float4 vs_TEXCOORD5 : TEXCOORD5;
					};
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					inter vert(app_in i)
					{
					    inter o;
UNITY_SETUP_INSTANCE_ID(i);
					float4 u_xlat0;
					int u_xlati0;
					float4 u_xlat1;
					float4 u_xlat2;
					    u_xlati0 = 0 + unity_BaseInstanceID;
					    u_xlati0 = u_xlati0 << 3;
					    u_xlat1 = i.in_POSITION0.yyyy * float4(unity_ObjectToWorld[0][1],unity_ObjectToWorld[1][1],unity_ObjectToWorld[2][1],unity_ObjectToWorld[3][1]);
					    u_xlat1 = float4(unity_ObjectToWorld[0][0],unity_ObjectToWorld[1][0],unity_ObjectToWorld[2][0],unity_ObjectToWorld[3][0]) * i.in_POSITION0.xxxx + u_xlat1;
					    u_xlat1 = float4(unity_ObjectToWorld[0][2],unity_ObjectToWorld[1][2],unity_ObjectToWorld[2][2],unity_ObjectToWorld[3][2]) * i.in_POSITION0.zzzz + u_xlat1;
					    u_xlat2 = u_xlat1 + float4(unity_ObjectToWorld[0][3],unity_ObjectToWorld[1][3],unity_ObjectToWorld[2][3],unity_ObjectToWorld[3][3]);
					    o.vs_TEXCOORD2.xyz = float4(unity_ObjectToWorld[0][3],unity_ObjectToWorld[1][3],unity_ObjectToWorld[2][3],unity_ObjectToWorld[3][3]).xyz * i.in_POSITION0.www + u_xlat1.xyz;
					    u_xlat1 = u_xlat2.yyyy * float4(unity_MatrixVP[0][1],unity_MatrixVP[1][1],unity_MatrixVP[2][1],unity_MatrixVP[3][1]);
					    u_xlat1 = float4(unity_MatrixVP[0][0],unity_MatrixVP[1][0],unity_MatrixVP[2][0],unity_MatrixVP[3][0]) * u_xlat2.xxxx + u_xlat1;
					    u_xlat1 = float4(unity_MatrixVP[0][2],unity_MatrixVP[1][2],unity_MatrixVP[2][2],unity_MatrixVP[3][2]) * u_xlat2.zzzz + u_xlat1;
					    u_xlat1 = float4(unity_MatrixVP[0][3],unity_MatrixVP[1][3],unity_MatrixVP[2][3],unity_MatrixVP[3][3]) * u_xlat2.wwww + u_xlat1;
					    o.vertex = u_xlat1;
					    o.vs_TEXCOORD0.xy = i.in_TEXCOORD1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat2.x = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][0],unity_WorldToObject[1][0],unity_WorldToObject[2][0],unity_WorldToObject[3][0]).xyz);
					    u_xlat2.y = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][1],unity_WorldToObject[1][1],unity_WorldToObject[2][1],unity_WorldToObject[3][1]).xyz);
					    u_xlat2.z = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][2],unity_WorldToObject[1][2],unity_WorldToObject[2][2],unity_WorldToObject[3][2]).xyz);
					    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat0.x = rsqrt(u_xlat0.x);
					    o.vs_TEXCOORD1.xyz = u_xlat0.xxx * u_xlat2.xyz;
					    u_xlat0.x = u_xlat1.y * _ProjectionParams.x;
					    u_xlat0.w = u_xlat0.x * 0.5;
					    u_xlat0.xz = u_xlat1.xw * float2(0.5, 0.5);
					    o.vs_TEXCOORD3.zw = u_xlat1.zw;
					    o.vs_TEXCOORD3.xy = u_xlat0.zz + u_xlat0.xw;
					    o.vs_COLOR0 = i.in_COLOR0;
					    o.vs_TEXCOORD4 = float4(0.0, 0.0, 0.0, 0.0);
					    o.vs_TEXCOORD5 = float4(0.0, 0.0, 0.0, 0.0);
					    return o;
					}

#endif

#if 1 && defined (DIRECTIONAL) && defined (LIGHTPROBE_SH) && !defined (FADE_FROM_VERTEX_COLORS) && !defined (TRIPLANAR) && !defined (SHADOWS_SCREEN) && defined (INSTANCING_ON)

					uniform float4 unused_0_0[12];
					uniform float4 _MainTex_ST;
					uniform float4 _Cloud1Tex_ST;
					uniform float4 _Cloud2Tex_ST;
					struct app_in {
						    float4 in_POSITION0 : POSITION;
						    float3 in_NORMAL0 : NORMAL;
						    float4 in_TEXCOORD1 : TEXCOORD1;
						    float4 in_COLOR0 : COLOR0;
						    UNITY_VERTEX_INPUT_INSTANCE_ID
					};
					struct inter {
						float4 vertex : SV_POSITION;
						float4 vs_TEXCOORD0 : TEXCOORD0;
						float2 vs_TEXCOORD1 : TEXCOORD1;
						float3 vs_TEXCOORD2 : TEXCOORD2;
						float3 vs_TEXCOORD3 : TEXCOORD3;
						float4 vs_TEXCOORD4 : TEXCOORD4;
						float4 vs_COLOR0 : COLOR0;
						float4 vs_TEXCOORD5 : TEXCOORD5;
						float4 vs_TEXCOORD6 : TEXCOORD6;
					};
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					inter vert(app_in i)
					{
					    inter o;
UNITY_SETUP_INSTANCE_ID(i);
					float4 u_xlat0;
					int u_xlati0;
					float4 u_xlat1;
					float4 u_xlat2;
					    u_xlati0 = 0 + unity_BaseInstanceID;
					    u_xlati0 = u_xlati0 << 3;
					    u_xlat1 = i.in_POSITION0.yyyy * float4(unity_ObjectToWorld[0][1],unity_ObjectToWorld[1][1],unity_ObjectToWorld[2][1],unity_ObjectToWorld[3][1]);
					    u_xlat1 = float4(unity_ObjectToWorld[0][0],unity_ObjectToWorld[1][0],unity_ObjectToWorld[2][0],unity_ObjectToWorld[3][0]) * i.in_POSITION0.xxxx + u_xlat1;
					    u_xlat1 = float4(unity_ObjectToWorld[0][2],unity_ObjectToWorld[1][2],unity_ObjectToWorld[2][2],unity_ObjectToWorld[3][2]) * i.in_POSITION0.zzzz + u_xlat1;
					    u_xlat2 = u_xlat1 + float4(unity_ObjectToWorld[0][3],unity_ObjectToWorld[1][3],unity_ObjectToWorld[2][3],unity_ObjectToWorld[3][3]);
					    o.vs_TEXCOORD3.xyz = float4(unity_ObjectToWorld[0][3],unity_ObjectToWorld[1][3],unity_ObjectToWorld[2][3],unity_ObjectToWorld[3][3]).xyz * i.in_POSITION0.www + u_xlat1.xyz;
					    u_xlat1 = u_xlat2.yyyy * float4(unity_MatrixVP[0][1],unity_MatrixVP[1][1],unity_MatrixVP[2][1],unity_MatrixVP[3][1]);
					    u_xlat1 = float4(unity_MatrixVP[0][0],unity_MatrixVP[1][0],unity_MatrixVP[2][0],unity_MatrixVP[3][0]) * u_xlat2.xxxx + u_xlat1;
					    u_xlat1 = float4(unity_MatrixVP[0][2],unity_MatrixVP[1][2],unity_MatrixVP[2][2],unity_MatrixVP[3][2]) * u_xlat2.zzzz + u_xlat1;
					    u_xlat1 = float4(unity_MatrixVP[0][3],unity_MatrixVP[1][3],unity_MatrixVP[2][3],unity_MatrixVP[3][3]) * u_xlat2.wwww + u_xlat1;
					    o.vertex = u_xlat1;
					    o.vs_TEXCOORD0.xy = i.in_TEXCOORD1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    o.vs_TEXCOORD0.zw = i.in_TEXCOORD1.xy * _Cloud1Tex_ST.xy + _Cloud1Tex_ST.zw;
					    o.vs_TEXCOORD1.xy = i.in_TEXCOORD1.xy * _Cloud2Tex_ST.xy + _Cloud2Tex_ST.zw;
					    u_xlat2.x = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][0],unity_WorldToObject[1][0],unity_WorldToObject[2][0],unity_WorldToObject[3][0]).xyz);
					    u_xlat2.y = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][1],unity_WorldToObject[1][1],unity_WorldToObject[2][1],unity_WorldToObject[3][1]).xyz);
					    u_xlat2.z = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][2],unity_WorldToObject[1][2],unity_WorldToObject[2][2],unity_WorldToObject[3][2]).xyz);
					    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat0.x = rsqrt(u_xlat0.x);
					    o.vs_TEXCOORD2.xyz = u_xlat0.xxx * u_xlat2.xyz;
					    u_xlat0.x = u_xlat1.y * _ProjectionParams.x;
					    u_xlat0.w = u_xlat0.x * 0.5;
					    u_xlat0.xz = u_xlat1.xw * float2(0.5, 0.5);
					    o.vs_TEXCOORD4.zw = u_xlat1.zw;
					    o.vs_TEXCOORD4.xy = u_xlat0.zz + u_xlat0.xw;
					    o.vs_COLOR0 = i.in_COLOR0;
					    o.vs_TEXCOORD5 = float4(0.0, 0.0, 0.0, 0.0);
					    o.vs_TEXCOORD6 = float4(0.0, 0.0, 0.0, 0.0);
					    return o;
					}

#endif

#if 1 && defined (DIRECTIONAL) && !defined (LIGHTPROBE_SH) && defined (FADE_FROM_VERTEX_COLORS) && !defined (TRIPLANAR) && defined (SHADOWS_SCREEN) && defined (INSTANCING_ON)

					uniform float4 unused_0_0[13];
					uniform float4 _MainTex_ST;
					uniform float4 _Cloud1Tex_ST;
					uniform float4 _Cloud2Tex_ST;
					struct app_in {
						    float4 in_POSITION0 : POSITION;
						    float3 in_NORMAL0 : NORMAL;
						    float4 in_TEXCOORD1 : TEXCOORD1;
						    float4 in_COLOR0 : COLOR0;
						    UNITY_VERTEX_INPUT_INSTANCE_ID
					};
					struct inter {
						float4 vertex : SV_POSITION;
						float4 vs_TEXCOORD0 : TEXCOORD0;
						float2 vs_TEXCOORD1 : TEXCOORD1;
						float3 vs_TEXCOORD2 : TEXCOORD2;
						float3 vs_TEXCOORD3 : TEXCOORD3;
						float4 vs_TEXCOORD4 : TEXCOORD4;
						float4 vs_COLOR0 : COLOR0;
						float4 vs_TEXCOORD5 : TEXCOORD5;
						float4 vs_TEXCOORD6 : TEXCOORD6;
					};
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					inter vert(app_in i)
					{
					    inter o;
UNITY_SETUP_INSTANCE_ID(i);
					float4 u_xlat0;
					int u_xlati0;
					float4 u_xlat1;
					float4 u_xlat2;
					    u_xlati0 = 0 + unity_BaseInstanceID;
					    u_xlati0 = u_xlati0 << 3;
					    u_xlat1 = i.in_POSITION0.yyyy * float4(unity_ObjectToWorld[0][1],unity_ObjectToWorld[1][1],unity_ObjectToWorld[2][1],unity_ObjectToWorld[3][1]);
					    u_xlat1 = float4(unity_ObjectToWorld[0][0],unity_ObjectToWorld[1][0],unity_ObjectToWorld[2][0],unity_ObjectToWorld[3][0]) * i.in_POSITION0.xxxx + u_xlat1;
					    u_xlat1 = float4(unity_ObjectToWorld[0][2],unity_ObjectToWorld[1][2],unity_ObjectToWorld[2][2],unity_ObjectToWorld[3][2]) * i.in_POSITION0.zzzz + u_xlat1;
					    u_xlat2 = u_xlat1 + float4(unity_ObjectToWorld[0][3],unity_ObjectToWorld[1][3],unity_ObjectToWorld[2][3],unity_ObjectToWorld[3][3]);
					    o.vs_TEXCOORD3.xyz = float4(unity_ObjectToWorld[0][3],unity_ObjectToWorld[1][3],unity_ObjectToWorld[2][3],unity_ObjectToWorld[3][3]).xyz * i.in_POSITION0.www + u_xlat1.xyz;
					    u_xlat1 = u_xlat2.yyyy * float4(unity_MatrixVP[0][1],unity_MatrixVP[1][1],unity_MatrixVP[2][1],unity_MatrixVP[3][1]);
					    u_xlat1 = float4(unity_MatrixVP[0][0],unity_MatrixVP[1][0],unity_MatrixVP[2][0],unity_MatrixVP[3][0]) * u_xlat2.xxxx + u_xlat1;
					    u_xlat1 = float4(unity_MatrixVP[0][2],unity_MatrixVP[1][2],unity_MatrixVP[2][2],unity_MatrixVP[3][2]) * u_xlat2.zzzz + u_xlat1;
					    u_xlat1 = float4(unity_MatrixVP[0][3],unity_MatrixVP[1][3],unity_MatrixVP[2][3],unity_MatrixVP[3][3]) * u_xlat2.wwww + u_xlat1;
					    o.vertex = u_xlat1;
					    o.vs_TEXCOORD0.xy = i.in_TEXCOORD1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    o.vs_TEXCOORD0.zw = i.in_TEXCOORD1.xy * _Cloud1Tex_ST.xy + _Cloud1Tex_ST.zw;
					    o.vs_TEXCOORD1.xy = i.in_TEXCOORD1.xy * _Cloud2Tex_ST.xy + _Cloud2Tex_ST.zw;
					    u_xlat2.x = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][0],unity_WorldToObject[1][0],unity_WorldToObject[2][0],unity_WorldToObject[3][0]).xyz);
					    u_xlat2.y = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][1],unity_WorldToObject[1][1],unity_WorldToObject[2][1],unity_WorldToObject[3][1]).xyz);
					    u_xlat2.z = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][2],unity_WorldToObject[1][2],unity_WorldToObject[2][2],unity_WorldToObject[3][2]).xyz);
					    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat0.x = rsqrt(u_xlat0.x);
					    o.vs_TEXCOORD2.xyz = u_xlat0.xxx * u_xlat2.xyz;
					    u_xlat0.x = u_xlat1.y * _ProjectionParams.x;
					    u_xlat0.w = u_xlat0.x * 0.5;
					    u_xlat0.xz = u_xlat1.xw * float2(0.5, 0.5);
					    u_xlat1.xy = u_xlat0.zz + u_xlat0.xw;
					    o.vs_TEXCOORD4 = u_xlat1;
					    o.vs_TEXCOORD5 = u_xlat1;
					    o.vs_COLOR0 = i.in_COLOR0;
					    o.vs_TEXCOORD6 = float4(0.0, 0.0, 0.0, 0.0);
					    return o;
					}

#endif

#if 1 && defined (DIRECTIONAL) && !defined (LIGHTPROBE_SH) && !defined (FADE_FROM_VERTEX_COLORS) && defined (TRIPLANAR) && defined (SHADOWS_SCREEN) && defined (INSTANCING_ON)

					uniform float4 unused_0_0[15];
					uniform float4 _MainTex_ST;
					struct app_in {
						    float4 in_POSITION0 : POSITION;
						    float3 in_NORMAL0 : NORMAL;
						    float4 in_TEXCOORD1 : TEXCOORD1;
						    float4 in_COLOR0 : COLOR0;
						    UNITY_VERTEX_INPUT_INSTANCE_ID
					};
					struct inter {
						float4 vertex : SV_POSITION;
						float2 vs_TEXCOORD0 : TEXCOORD0;
						float3 vs_TEXCOORD1 : TEXCOORD1;
						float3 vs_TEXCOORD2 : TEXCOORD2;
						float4 vs_TEXCOORD3 : TEXCOORD3;
						float4 vs_COLOR0 : COLOR0;
						float4 vs_TEXCOORD4 : TEXCOORD4;
						float4 vs_TEXCOORD5 : TEXCOORD5;
					};
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					inter vert(app_in i)
					{
					    inter o;
UNITY_SETUP_INSTANCE_ID(i);
					float4 u_xlat0;
					int u_xlati0;
					float4 u_xlat1;
					float4 u_xlat2;
					    u_xlati0 = 0 + unity_BaseInstanceID;
					    u_xlati0 = u_xlati0 << 3;
					    u_xlat1 = i.in_POSITION0.yyyy * float4(unity_ObjectToWorld[0][1],unity_ObjectToWorld[1][1],unity_ObjectToWorld[2][1],unity_ObjectToWorld[3][1]);
					    u_xlat1 = float4(unity_ObjectToWorld[0][0],unity_ObjectToWorld[1][0],unity_ObjectToWorld[2][0],unity_ObjectToWorld[3][0]) * i.in_POSITION0.xxxx + u_xlat1;
					    u_xlat1 = float4(unity_ObjectToWorld[0][2],unity_ObjectToWorld[1][2],unity_ObjectToWorld[2][2],unity_ObjectToWorld[3][2]) * i.in_POSITION0.zzzz + u_xlat1;
					    u_xlat2 = u_xlat1 + float4(unity_ObjectToWorld[0][3],unity_ObjectToWorld[1][3],unity_ObjectToWorld[2][3],unity_ObjectToWorld[3][3]);
					    o.vs_TEXCOORD2.xyz = float4(unity_ObjectToWorld[0][3],unity_ObjectToWorld[1][3],unity_ObjectToWorld[2][3],unity_ObjectToWorld[3][3]).xyz * i.in_POSITION0.www + u_xlat1.xyz;
					    u_xlat1 = u_xlat2.yyyy * float4(unity_MatrixVP[0][1],unity_MatrixVP[1][1],unity_MatrixVP[2][1],unity_MatrixVP[3][1]);
					    u_xlat1 = float4(unity_MatrixVP[0][0],unity_MatrixVP[1][0],unity_MatrixVP[2][0],unity_MatrixVP[3][0]) * u_xlat2.xxxx + u_xlat1;
					    u_xlat1 = float4(unity_MatrixVP[0][2],unity_MatrixVP[1][2],unity_MatrixVP[2][2],unity_MatrixVP[3][2]) * u_xlat2.zzzz + u_xlat1;
					    u_xlat1 = float4(unity_MatrixVP[0][3],unity_MatrixVP[1][3],unity_MatrixVP[2][3],unity_MatrixVP[3][3]) * u_xlat2.wwww + u_xlat1;
					    o.vertex = u_xlat1;
					    o.vs_TEXCOORD0.xy = i.in_TEXCOORD1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat2.x = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][0],unity_WorldToObject[1][0],unity_WorldToObject[2][0],unity_WorldToObject[3][0]).xyz);
					    u_xlat2.y = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][1],unity_WorldToObject[1][1],unity_WorldToObject[2][1],unity_WorldToObject[3][1]).xyz);
					    u_xlat2.z = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][2],unity_WorldToObject[1][2],unity_WorldToObject[2][2],unity_WorldToObject[3][2]).xyz);
					    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat0.x = rsqrt(u_xlat0.x);
					    o.vs_TEXCOORD1.xyz = u_xlat0.xxx * u_xlat2.xyz;
					    u_xlat0.x = u_xlat1.y * _ProjectionParams.x;
					    u_xlat0.w = u_xlat0.x * 0.5;
					    u_xlat0.xz = u_xlat1.xw * float2(0.5, 0.5);
					    u_xlat1.xy = u_xlat0.zz + u_xlat0.xw;
					    o.vs_TEXCOORD3 = u_xlat1;
					    o.vs_TEXCOORD4 = u_xlat1;
					    o.vs_COLOR0 = i.in_COLOR0;
					    o.vs_TEXCOORD5 = float4(0.0, 0.0, 0.0, 0.0);
					    return o;
					}

#endif

#if 1 && defined (DIRECTIONAL) && !defined (LIGHTPROBE_SH) && !defined (FADE_FROM_VERTEX_COLORS) && !defined (TRIPLANAR) && defined (SHADOWS_SCREEN) && defined (INSTANCING_ON)

					uniform float4 unused_0_0[13];
					uniform float4 _MainTex_ST;
					uniform float4 _Cloud1Tex_ST;
					uniform float4 _Cloud2Tex_ST;
					struct app_in {
						    float4 in_POSITION0 : POSITION;
						    float3 in_NORMAL0 : NORMAL;
						    float4 in_TEXCOORD1 : TEXCOORD1;
						    float4 in_COLOR0 : COLOR0;
						    UNITY_VERTEX_INPUT_INSTANCE_ID
					};
					struct inter {
						float4 vertex : SV_POSITION;
						float4 vs_TEXCOORD0 : TEXCOORD0;
						float2 vs_TEXCOORD1 : TEXCOORD1;
						float3 vs_TEXCOORD2 : TEXCOORD2;
						float3 vs_TEXCOORD3 : TEXCOORD3;
						float4 vs_TEXCOORD4 : TEXCOORD4;
						float4 vs_COLOR0 : COLOR0;
						float4 vs_TEXCOORD5 : TEXCOORD5;
						float4 vs_TEXCOORD6 : TEXCOORD6;
					};
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					inter vert(app_in i)
					{
					    inter o;
UNITY_SETUP_INSTANCE_ID(i);
					float4 u_xlat0;
					int u_xlati0;
					float4 u_xlat1;
					float4 u_xlat2;
					    u_xlati0 = 0 + unity_BaseInstanceID;
					    u_xlati0 = u_xlati0 << 3;
					    u_xlat1 = i.in_POSITION0.yyyy * float4(unity_ObjectToWorld[0][1],unity_ObjectToWorld[1][1],unity_ObjectToWorld[2][1],unity_ObjectToWorld[3][1]);
					    u_xlat1 = float4(unity_ObjectToWorld[0][0],unity_ObjectToWorld[1][0],unity_ObjectToWorld[2][0],unity_ObjectToWorld[3][0]) * i.in_POSITION0.xxxx + u_xlat1;
					    u_xlat1 = float4(unity_ObjectToWorld[0][2],unity_ObjectToWorld[1][2],unity_ObjectToWorld[2][2],unity_ObjectToWorld[3][2]) * i.in_POSITION0.zzzz + u_xlat1;
					    u_xlat2 = u_xlat1 + float4(unity_ObjectToWorld[0][3],unity_ObjectToWorld[1][3],unity_ObjectToWorld[2][3],unity_ObjectToWorld[3][3]);
					    o.vs_TEXCOORD3.xyz = float4(unity_ObjectToWorld[0][3],unity_ObjectToWorld[1][3],unity_ObjectToWorld[2][3],unity_ObjectToWorld[3][3]).xyz * i.in_POSITION0.www + u_xlat1.xyz;
					    u_xlat1 = u_xlat2.yyyy * float4(unity_MatrixVP[0][1],unity_MatrixVP[1][1],unity_MatrixVP[2][1],unity_MatrixVP[3][1]);
					    u_xlat1 = float4(unity_MatrixVP[0][0],unity_MatrixVP[1][0],unity_MatrixVP[2][0],unity_MatrixVP[3][0]) * u_xlat2.xxxx + u_xlat1;
					    u_xlat1 = float4(unity_MatrixVP[0][2],unity_MatrixVP[1][2],unity_MatrixVP[2][2],unity_MatrixVP[3][2]) * u_xlat2.zzzz + u_xlat1;
					    u_xlat1 = float4(unity_MatrixVP[0][3],unity_MatrixVP[1][3],unity_MatrixVP[2][3],unity_MatrixVP[3][3]) * u_xlat2.wwww + u_xlat1;
					    o.vertex = u_xlat1;
					    o.vs_TEXCOORD0.xy = i.in_TEXCOORD1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    o.vs_TEXCOORD0.zw = i.in_TEXCOORD1.xy * _Cloud1Tex_ST.xy + _Cloud1Tex_ST.zw;
					    o.vs_TEXCOORD1.xy = i.in_TEXCOORD1.xy * _Cloud2Tex_ST.xy + _Cloud2Tex_ST.zw;
					    u_xlat2.x = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][0],unity_WorldToObject[1][0],unity_WorldToObject[2][0],unity_WorldToObject[3][0]).xyz);
					    u_xlat2.y = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][1],unity_WorldToObject[1][1],unity_WorldToObject[2][1],unity_WorldToObject[3][1]).xyz);
					    u_xlat2.z = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][2],unity_WorldToObject[1][2],unity_WorldToObject[2][2],unity_WorldToObject[3][2]).xyz);
					    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat0.x = rsqrt(u_xlat0.x);
					    o.vs_TEXCOORD2.xyz = u_xlat0.xxx * u_xlat2.xyz;
					    u_xlat0.x = u_xlat1.y * _ProjectionParams.x;
					    u_xlat0.w = u_xlat0.x * 0.5;
					    u_xlat0.xz = u_xlat1.xw * float2(0.5, 0.5);
					    u_xlat1.xy = u_xlat0.zz + u_xlat0.xw;
					    o.vs_TEXCOORD4 = u_xlat1;
					    o.vs_TEXCOORD5 = u_xlat1;
					    o.vs_COLOR0 = i.in_COLOR0;
					    o.vs_TEXCOORD6 = float4(0.0, 0.0, 0.0, 0.0);
					    return o;
					}

#endif

#if 1 && defined (DIRECTIONAL) && defined (LIGHTPROBE_SH) && defined (FADE_FROM_VERTEX_COLORS) && !defined (TRIPLANAR) && defined (SHADOWS_SCREEN) && defined (INSTANCING_ON)

					uniform float4 unused_0_0[13];
					uniform float4 _MainTex_ST;
					uniform float4 _Cloud1Tex_ST;
					uniform float4 _Cloud2Tex_ST;
					struct app_in {
						    float4 in_POSITION0 : POSITION;
						    float3 in_NORMAL0 : NORMAL;
						    float4 in_TEXCOORD1 : TEXCOORD1;
						    float4 in_COLOR0 : COLOR0;
						    UNITY_VERTEX_INPUT_INSTANCE_ID
					};
					struct inter {
						float4 vertex : SV_POSITION;
						float4 vs_TEXCOORD0 : TEXCOORD0;
						float2 vs_TEXCOORD1 : TEXCOORD1;
						float3 vs_TEXCOORD2 : TEXCOORD2;
						float3 vs_TEXCOORD3 : TEXCOORD3;
						float4 vs_TEXCOORD4 : TEXCOORD4;
						float4 vs_COLOR0 : COLOR0;
						float4 vs_TEXCOORD5 : TEXCOORD5;
						float4 vs_TEXCOORD6 : TEXCOORD6;
					};
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					inter vert(app_in i)
					{
					    inter o;
UNITY_SETUP_INSTANCE_ID(i);
					float4 u_xlat0;
					int u_xlati0;
					float4 u_xlat1;
					float4 u_xlat2;
					    u_xlati0 = 0 + unity_BaseInstanceID;
					    u_xlati0 = u_xlati0 << 3;
					    u_xlat1 = i.in_POSITION0.yyyy * float4(unity_ObjectToWorld[0][1],unity_ObjectToWorld[1][1],unity_ObjectToWorld[2][1],unity_ObjectToWorld[3][1]);
					    u_xlat1 = float4(unity_ObjectToWorld[0][0],unity_ObjectToWorld[1][0],unity_ObjectToWorld[2][0],unity_ObjectToWorld[3][0]) * i.in_POSITION0.xxxx + u_xlat1;
					    u_xlat1 = float4(unity_ObjectToWorld[0][2],unity_ObjectToWorld[1][2],unity_ObjectToWorld[2][2],unity_ObjectToWorld[3][2]) * i.in_POSITION0.zzzz + u_xlat1;
					    u_xlat2 = u_xlat1 + float4(unity_ObjectToWorld[0][3],unity_ObjectToWorld[1][3],unity_ObjectToWorld[2][3],unity_ObjectToWorld[3][3]);
					    o.vs_TEXCOORD3.xyz = float4(unity_ObjectToWorld[0][3],unity_ObjectToWorld[1][3],unity_ObjectToWorld[2][3],unity_ObjectToWorld[3][3]).xyz * i.in_POSITION0.www + u_xlat1.xyz;
					    u_xlat1 = u_xlat2.yyyy * float4(unity_MatrixVP[0][1],unity_MatrixVP[1][1],unity_MatrixVP[2][1],unity_MatrixVP[3][1]);
					    u_xlat1 = float4(unity_MatrixVP[0][0],unity_MatrixVP[1][0],unity_MatrixVP[2][0],unity_MatrixVP[3][0]) * u_xlat2.xxxx + u_xlat1;
					    u_xlat1 = float4(unity_MatrixVP[0][2],unity_MatrixVP[1][2],unity_MatrixVP[2][2],unity_MatrixVP[3][2]) * u_xlat2.zzzz + u_xlat1;
					    u_xlat1 = float4(unity_MatrixVP[0][3],unity_MatrixVP[1][3],unity_MatrixVP[2][3],unity_MatrixVP[3][3]) * u_xlat2.wwww + u_xlat1;
					    o.vertex = u_xlat1;
					    o.vs_TEXCOORD0.xy = i.in_TEXCOORD1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    o.vs_TEXCOORD0.zw = i.in_TEXCOORD1.xy * _Cloud1Tex_ST.xy + _Cloud1Tex_ST.zw;
					    o.vs_TEXCOORD1.xy = i.in_TEXCOORD1.xy * _Cloud2Tex_ST.xy + _Cloud2Tex_ST.zw;
					    u_xlat2.x = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][0],unity_WorldToObject[1][0],unity_WorldToObject[2][0],unity_WorldToObject[3][0]).xyz);
					    u_xlat2.y = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][1],unity_WorldToObject[1][1],unity_WorldToObject[2][1],unity_WorldToObject[3][1]).xyz);
					    u_xlat2.z = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][2],unity_WorldToObject[1][2],unity_WorldToObject[2][2],unity_WorldToObject[3][2]).xyz);
					    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat0.x = rsqrt(u_xlat0.x);
					    o.vs_TEXCOORD2.xyz = u_xlat0.xxx * u_xlat2.xyz;
					    u_xlat0.x = u_xlat1.y * _ProjectionParams.x;
					    u_xlat0.w = u_xlat0.x * 0.5;
					    u_xlat0.xz = u_xlat1.xw * float2(0.5, 0.5);
					    u_xlat1.xy = u_xlat0.zz + u_xlat0.xw;
					    o.vs_TEXCOORD4 = u_xlat1;
					    o.vs_TEXCOORD5 = u_xlat1;
					    o.vs_COLOR0 = i.in_COLOR0;
					    o.vs_TEXCOORD6 = float4(0.0, 0.0, 0.0, 0.0);
					    return o;
					}

#endif

#if 1 && defined (DIRECTIONAL) && defined (LIGHTPROBE_SH) && !defined (FADE_FROM_VERTEX_COLORS) && defined (TRIPLANAR) && defined (SHADOWS_SCREEN) && defined (INSTANCING_ON)

					uniform float4 unused_0_0[15];
					uniform float4 _MainTex_ST;
					struct app_in {
						    float4 in_POSITION0 : POSITION;
						    float3 in_NORMAL0 : NORMAL;
						    float4 in_TEXCOORD1 : TEXCOORD1;
						    float4 in_COLOR0 : COLOR0;
						    UNITY_VERTEX_INPUT_INSTANCE_ID
					};
					struct inter {
						float4 vertex : SV_POSITION;
						float2 vs_TEXCOORD0 : TEXCOORD0;
						float3 vs_TEXCOORD1 : TEXCOORD1;
						float3 vs_TEXCOORD2 : TEXCOORD2;
						float4 vs_TEXCOORD3 : TEXCOORD3;
						float4 vs_COLOR0 : COLOR0;
						float4 vs_TEXCOORD4 : TEXCOORD4;
						float4 vs_TEXCOORD5 : TEXCOORD5;
					};
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					inter vert(app_in i)
					{
					    inter o;
UNITY_SETUP_INSTANCE_ID(i);
					float4 u_xlat0;
					int u_xlati0;
					float4 u_xlat1;
					float4 u_xlat2;
					    u_xlati0 = 0 + unity_BaseInstanceID;
					    u_xlati0 = u_xlati0 << 3;
					    u_xlat1 = i.in_POSITION0.yyyy * float4(unity_ObjectToWorld[0][1],unity_ObjectToWorld[1][1],unity_ObjectToWorld[2][1],unity_ObjectToWorld[3][1]);
					    u_xlat1 = float4(unity_ObjectToWorld[0][0],unity_ObjectToWorld[1][0],unity_ObjectToWorld[2][0],unity_ObjectToWorld[3][0]) * i.in_POSITION0.xxxx + u_xlat1;
					    u_xlat1 = float4(unity_ObjectToWorld[0][2],unity_ObjectToWorld[1][2],unity_ObjectToWorld[2][2],unity_ObjectToWorld[3][2]) * i.in_POSITION0.zzzz + u_xlat1;
					    u_xlat2 = u_xlat1 + float4(unity_ObjectToWorld[0][3],unity_ObjectToWorld[1][3],unity_ObjectToWorld[2][3],unity_ObjectToWorld[3][3]);
					    o.vs_TEXCOORD2.xyz = float4(unity_ObjectToWorld[0][3],unity_ObjectToWorld[1][3],unity_ObjectToWorld[2][3],unity_ObjectToWorld[3][3]).xyz * i.in_POSITION0.www + u_xlat1.xyz;
					    u_xlat1 = u_xlat2.yyyy * float4(unity_MatrixVP[0][1],unity_MatrixVP[1][1],unity_MatrixVP[2][1],unity_MatrixVP[3][1]);
					    u_xlat1 = float4(unity_MatrixVP[0][0],unity_MatrixVP[1][0],unity_MatrixVP[2][0],unity_MatrixVP[3][0]) * u_xlat2.xxxx + u_xlat1;
					    u_xlat1 = float4(unity_MatrixVP[0][2],unity_MatrixVP[1][2],unity_MatrixVP[2][2],unity_MatrixVP[3][2]) * u_xlat2.zzzz + u_xlat1;
					    u_xlat1 = float4(unity_MatrixVP[0][3],unity_MatrixVP[1][3],unity_MatrixVP[2][3],unity_MatrixVP[3][3]) * u_xlat2.wwww + u_xlat1;
					    o.vertex = u_xlat1;
					    o.vs_TEXCOORD0.xy = i.in_TEXCOORD1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat2.x = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][0],unity_WorldToObject[1][0],unity_WorldToObject[2][0],unity_WorldToObject[3][0]).xyz);
					    u_xlat2.y = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][1],unity_WorldToObject[1][1],unity_WorldToObject[2][1],unity_WorldToObject[3][1]).xyz);
					    u_xlat2.z = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][2],unity_WorldToObject[1][2],unity_WorldToObject[2][2],unity_WorldToObject[3][2]).xyz);
					    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat0.x = rsqrt(u_xlat0.x);
					    o.vs_TEXCOORD1.xyz = u_xlat0.xxx * u_xlat2.xyz;
					    u_xlat0.x = u_xlat1.y * _ProjectionParams.x;
					    u_xlat0.w = u_xlat0.x * 0.5;
					    u_xlat0.xz = u_xlat1.xw * float2(0.5, 0.5);
					    u_xlat1.xy = u_xlat0.zz + u_xlat0.xw;
					    o.vs_TEXCOORD3 = u_xlat1;
					    o.vs_TEXCOORD4 = u_xlat1;
					    o.vs_COLOR0 = i.in_COLOR0;
					    o.vs_TEXCOORD5 = float4(0.0, 0.0, 0.0, 0.0);
					    return o;
					}

#endif

#if 1 && defined (DIRECTIONAL) && defined (LIGHTPROBE_SH) && !defined (FADE_FROM_VERTEX_COLORS) && !defined (TRIPLANAR) && defined (SHADOWS_SCREEN) && defined (INSTANCING_ON)

					uniform float4 unused_0_0[13];
					uniform float4 _MainTex_ST;
					uniform float4 _Cloud1Tex_ST;
					uniform float4 _Cloud2Tex_ST;
					struct app_in {
						    float4 in_POSITION0 : POSITION;
						    float3 in_NORMAL0 : NORMAL;
						    float4 in_TEXCOORD1 : TEXCOORD1;
						    float4 in_COLOR0 : COLOR0;
						    UNITY_VERTEX_INPUT_INSTANCE_ID
					};
					struct inter {
						float4 vertex : SV_POSITION;
						float4 vs_TEXCOORD0 : TEXCOORD0;
						float2 vs_TEXCOORD1 : TEXCOORD1;
						float3 vs_TEXCOORD2 : TEXCOORD2;
						float3 vs_TEXCOORD3 : TEXCOORD3;
						float4 vs_TEXCOORD4 : TEXCOORD4;
						float4 vs_COLOR0 : COLOR0;
						float4 vs_TEXCOORD5 : TEXCOORD5;
						float4 vs_TEXCOORD6 : TEXCOORD6;
					};
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					inter vert(app_in i)
					{
					    inter o;
UNITY_SETUP_INSTANCE_ID(i);
					float4 u_xlat0;
					int u_xlati0;
					float4 u_xlat1;
					float4 u_xlat2;
					    u_xlati0 = 0 + unity_BaseInstanceID;
					    u_xlati0 = u_xlati0 << 3;
					    u_xlat1 = i.in_POSITION0.yyyy * float4(unity_ObjectToWorld[0][1],unity_ObjectToWorld[1][1],unity_ObjectToWorld[2][1],unity_ObjectToWorld[3][1]);
					    u_xlat1 = float4(unity_ObjectToWorld[0][0],unity_ObjectToWorld[1][0],unity_ObjectToWorld[2][0],unity_ObjectToWorld[3][0]) * i.in_POSITION0.xxxx + u_xlat1;
					    u_xlat1 = float4(unity_ObjectToWorld[0][2],unity_ObjectToWorld[1][2],unity_ObjectToWorld[2][2],unity_ObjectToWorld[3][2]) * i.in_POSITION0.zzzz + u_xlat1;
					    u_xlat2 = u_xlat1 + float4(unity_ObjectToWorld[0][3],unity_ObjectToWorld[1][3],unity_ObjectToWorld[2][3],unity_ObjectToWorld[3][3]);
					    o.vs_TEXCOORD3.xyz = float4(unity_ObjectToWorld[0][3],unity_ObjectToWorld[1][3],unity_ObjectToWorld[2][3],unity_ObjectToWorld[3][3]).xyz * i.in_POSITION0.www + u_xlat1.xyz;
					    u_xlat1 = u_xlat2.yyyy * float4(unity_MatrixVP[0][1],unity_MatrixVP[1][1],unity_MatrixVP[2][1],unity_MatrixVP[3][1]);
					    u_xlat1 = float4(unity_MatrixVP[0][0],unity_MatrixVP[1][0],unity_MatrixVP[2][0],unity_MatrixVP[3][0]) * u_xlat2.xxxx + u_xlat1;
					    u_xlat1 = float4(unity_MatrixVP[0][2],unity_MatrixVP[1][2],unity_MatrixVP[2][2],unity_MatrixVP[3][2]) * u_xlat2.zzzz + u_xlat1;
					    u_xlat1 = float4(unity_MatrixVP[0][3],unity_MatrixVP[1][3],unity_MatrixVP[2][3],unity_MatrixVP[3][3]) * u_xlat2.wwww + u_xlat1;
					    o.vertex = u_xlat1;
					    o.vs_TEXCOORD0.xy = i.in_TEXCOORD1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    o.vs_TEXCOORD0.zw = i.in_TEXCOORD1.xy * _Cloud1Tex_ST.xy + _Cloud1Tex_ST.zw;
					    o.vs_TEXCOORD1.xy = i.in_TEXCOORD1.xy * _Cloud2Tex_ST.xy + _Cloud2Tex_ST.zw;
					    u_xlat2.x = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][0],unity_WorldToObject[1][0],unity_WorldToObject[2][0],unity_WorldToObject[3][0]).xyz);
					    u_xlat2.y = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][1],unity_WorldToObject[1][1],unity_WorldToObject[2][1],unity_WorldToObject[3][1]).xyz);
					    u_xlat2.z = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][2],unity_WorldToObject[1][2],unity_WorldToObject[2][2],unity_WorldToObject[3][2]).xyz);
					    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat0.x = rsqrt(u_xlat0.x);
					    o.vs_TEXCOORD2.xyz = u_xlat0.xxx * u_xlat2.xyz;
					    u_xlat0.x = u_xlat1.y * _ProjectionParams.x;
					    u_xlat0.w = u_xlat0.x * 0.5;
					    u_xlat0.xz = u_xlat1.xw * float2(0.5, 0.5);
					    u_xlat1.xy = u_xlat0.zz + u_xlat0.xw;
					    o.vs_TEXCOORD4 = u_xlat1;
					    o.vs_TEXCOORD5 = u_xlat1;
					    o.vs_COLOR0 = i.in_COLOR0;
					    o.vs_TEXCOORD6 = float4(0.0, 0.0, 0.0, 0.0);
					    return o;
					}

#endif

#if 1 && defined (DIRECTIONAL) && !defined (LIGHTPROBE_SH) && defined (FADE_FROM_VERTEX_COLORS) && !defined (TRIPLANAR) && !defined (SHADOWS_SCREEN) && defined (INSTANCING_ON)

					uniform float4 unused_0_0[12];
					uniform float4 _MainTex_ST;
					uniform float4 _Cloud1Tex_ST;
					uniform float4 _Cloud2Tex_ST;
					struct app_in {
						    float4 in_POSITION0 : POSITION;
						    float3 in_NORMAL0 : NORMAL;
						    float4 in_TEXCOORD1 : TEXCOORD1;
						    float4 in_COLOR0 : COLOR0;
						    UNITY_VERTEX_INPUT_INSTANCE_ID
					};
					struct inter {
						float4 vertex : SV_POSITION;
						float4 vs_TEXCOORD0 : TEXCOORD0;
						float2 vs_TEXCOORD1 : TEXCOORD1;
						float3 vs_TEXCOORD2 : TEXCOORD2;
						float3 vs_TEXCOORD3 : TEXCOORD3;
						float4 vs_TEXCOORD4 : TEXCOORD4;
						float4 vs_COLOR0 : COLOR0;
						float4 vs_TEXCOORD5 : TEXCOORD5;
						float4 vs_TEXCOORD6 : TEXCOORD6;
					};
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					inter vert(app_in i)
					{
					    inter o;
UNITY_SETUP_INSTANCE_ID(i);
					float4 u_xlat0;
					int u_xlati0;
					float4 u_xlat1;
					float4 u_xlat2;
					    u_xlati0 = 0 + unity_BaseInstanceID;
					    u_xlati0 = u_xlati0 << 3;
					    u_xlat1 = i.in_POSITION0.yyyy * float4(unity_ObjectToWorld[0][1],unity_ObjectToWorld[1][1],unity_ObjectToWorld[2][1],unity_ObjectToWorld[3][1]);
					    u_xlat1 = float4(unity_ObjectToWorld[0][0],unity_ObjectToWorld[1][0],unity_ObjectToWorld[2][0],unity_ObjectToWorld[3][0]) * i.in_POSITION0.xxxx + u_xlat1;
					    u_xlat1 = float4(unity_ObjectToWorld[0][2],unity_ObjectToWorld[1][2],unity_ObjectToWorld[2][2],unity_ObjectToWorld[3][2]) * i.in_POSITION0.zzzz + u_xlat1;
					    u_xlat2 = u_xlat1 + float4(unity_ObjectToWorld[0][3],unity_ObjectToWorld[1][3],unity_ObjectToWorld[2][3],unity_ObjectToWorld[3][3]);
					    o.vs_TEXCOORD3.xyz = float4(unity_ObjectToWorld[0][3],unity_ObjectToWorld[1][3],unity_ObjectToWorld[2][3],unity_ObjectToWorld[3][3]).xyz * i.in_POSITION0.www + u_xlat1.xyz;
					    u_xlat1 = u_xlat2.yyyy * float4(unity_MatrixVP[0][1],unity_MatrixVP[1][1],unity_MatrixVP[2][1],unity_MatrixVP[3][1]);
					    u_xlat1 = float4(unity_MatrixVP[0][0],unity_MatrixVP[1][0],unity_MatrixVP[2][0],unity_MatrixVP[3][0]) * u_xlat2.xxxx + u_xlat1;
					    u_xlat1 = float4(unity_MatrixVP[0][2],unity_MatrixVP[1][2],unity_MatrixVP[2][2],unity_MatrixVP[3][2]) * u_xlat2.zzzz + u_xlat1;
					    u_xlat1 = float4(unity_MatrixVP[0][3],unity_MatrixVP[1][3],unity_MatrixVP[2][3],unity_MatrixVP[3][3]) * u_xlat2.wwww + u_xlat1;
					    o.vertex = u_xlat1;
					    o.vs_TEXCOORD0.xy = i.in_TEXCOORD1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    o.vs_TEXCOORD0.zw = i.in_TEXCOORD1.xy * _Cloud1Tex_ST.xy + _Cloud1Tex_ST.zw;
					    o.vs_TEXCOORD1.xy = i.in_TEXCOORD1.xy * _Cloud2Tex_ST.xy + _Cloud2Tex_ST.zw;
					    u_xlat2.x = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][0],unity_WorldToObject[1][0],unity_WorldToObject[2][0],unity_WorldToObject[3][0]).xyz);
					    u_xlat2.y = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][1],unity_WorldToObject[1][1],unity_WorldToObject[2][1],unity_WorldToObject[3][1]).xyz);
					    u_xlat2.z = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][2],unity_WorldToObject[1][2],unity_WorldToObject[2][2],unity_WorldToObject[3][2]).xyz);
					    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat0.x = rsqrt(u_xlat0.x);
					    o.vs_TEXCOORD2.xyz = u_xlat0.xxx * u_xlat2.xyz;
					    u_xlat0.x = u_xlat1.y * _ProjectionParams.x;
					    u_xlat0.w = u_xlat0.x * 0.5;
					    u_xlat0.xz = u_xlat1.xw * float2(0.5, 0.5);
					    o.vs_TEXCOORD4.zw = u_xlat1.zw;
					    o.vs_TEXCOORD4.xy = u_xlat0.zz + u_xlat0.xw;
					    o.vs_COLOR0 = i.in_COLOR0;
					    o.vs_TEXCOORD5 = float4(0.0, 0.0, 0.0, 0.0);
					    o.vs_TEXCOORD6 = float4(0.0, 0.0, 0.0, 0.0);
					    return o;
					}

#endif

#if 1 && defined (DIRECTIONAL) && !defined (LIGHTPROBE_SH) && !defined (FADE_FROM_VERTEX_COLORS) && defined (TRIPLANAR) && !defined (SHADOWS_SCREEN) && defined (INSTANCING_ON)

					uniform float4 unused_0_0[14];
					uniform float4 _MainTex_ST;
					struct app_in {
						    float4 in_POSITION0 : POSITION;
						    float3 in_NORMAL0 : NORMAL;
						    float4 in_TEXCOORD1 : TEXCOORD1;
						    float4 in_COLOR0 : COLOR0;
						    UNITY_VERTEX_INPUT_INSTANCE_ID
					};
					struct inter {
						float4 vertex : SV_POSITION;
						float2 vs_TEXCOORD0 : TEXCOORD0;
						float3 vs_TEXCOORD1 : TEXCOORD1;
						float3 vs_TEXCOORD2 : TEXCOORD2;
						float4 vs_TEXCOORD3 : TEXCOORD3;
						float4 vs_COLOR0 : COLOR0;
						float4 vs_TEXCOORD4 : TEXCOORD4;
						float4 vs_TEXCOORD5 : TEXCOORD5;
					};
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					inter vert(app_in i)
					{
					    inter o;
UNITY_SETUP_INSTANCE_ID(i);
					float4 u_xlat0;
					int u_xlati0;
					float4 u_xlat1;
					float4 u_xlat2;
					    u_xlati0 = 0 + unity_BaseInstanceID;
					    u_xlati0 = u_xlati0 << 3;
					    u_xlat1 = i.in_POSITION0.yyyy * float4(unity_ObjectToWorld[0][1],unity_ObjectToWorld[1][1],unity_ObjectToWorld[2][1],unity_ObjectToWorld[3][1]);
					    u_xlat1 = float4(unity_ObjectToWorld[0][0],unity_ObjectToWorld[1][0],unity_ObjectToWorld[2][0],unity_ObjectToWorld[3][0]) * i.in_POSITION0.xxxx + u_xlat1;
					    u_xlat1 = float4(unity_ObjectToWorld[0][2],unity_ObjectToWorld[1][2],unity_ObjectToWorld[2][2],unity_ObjectToWorld[3][2]) * i.in_POSITION0.zzzz + u_xlat1;
					    u_xlat2 = u_xlat1 + float4(unity_ObjectToWorld[0][3],unity_ObjectToWorld[1][3],unity_ObjectToWorld[2][3],unity_ObjectToWorld[3][3]);
					    o.vs_TEXCOORD2.xyz = float4(unity_ObjectToWorld[0][3],unity_ObjectToWorld[1][3],unity_ObjectToWorld[2][3],unity_ObjectToWorld[3][3]).xyz * i.in_POSITION0.www + u_xlat1.xyz;
					    u_xlat1 = u_xlat2.yyyy * float4(unity_MatrixVP[0][1],unity_MatrixVP[1][1],unity_MatrixVP[2][1],unity_MatrixVP[3][1]);
					    u_xlat1 = float4(unity_MatrixVP[0][0],unity_MatrixVP[1][0],unity_MatrixVP[2][0],unity_MatrixVP[3][0]) * u_xlat2.xxxx + u_xlat1;
					    u_xlat1 = float4(unity_MatrixVP[0][2],unity_MatrixVP[1][2],unity_MatrixVP[2][2],unity_MatrixVP[3][2]) * u_xlat2.zzzz + u_xlat1;
					    u_xlat1 = float4(unity_MatrixVP[0][3],unity_MatrixVP[1][3],unity_MatrixVP[2][3],unity_MatrixVP[3][3]) * u_xlat2.wwww + u_xlat1;
					    o.vertex = u_xlat1;
					    o.vs_TEXCOORD0.xy = i.in_TEXCOORD1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat2.x = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][0],unity_WorldToObject[1][0],unity_WorldToObject[2][0],unity_WorldToObject[3][0]).xyz);
					    u_xlat2.y = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][1],unity_WorldToObject[1][1],unity_WorldToObject[2][1],unity_WorldToObject[3][1]).xyz);
					    u_xlat2.z = dot(i.in_NORMAL0.xyz, float4(unity_WorldToObject[0][2],unity_WorldToObject[1][2],unity_WorldToObject[2][2],unity_WorldToObject[3][2]).xyz);
					    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
					    u_xlat0.x = rsqrt(u_xlat0.x);
					    o.vs_TEXCOORD1.xyz = u_xlat0.xxx * u_xlat2.xyz;
					    u_xlat0.x = u_xlat1.y * _ProjectionParams.x;
					    u_xlat0.w = u_xlat0.x * 0.5;
					    u_xlat0.xz = u_xlat1.xw * float2(0.5, 0.5);
					    o.vs_TEXCOORD3.zw = u_xlat1.zw;
					    o.vs_TEXCOORD3.xy = u_xlat0.zz + u_xlat0.xw;
					    o.vs_COLOR0 = i.in_COLOR0;
					    o.vs_TEXCOORD4 = float4(0.0, 0.0, 0.0, 0.0);
					    o.vs_TEXCOORD5 = float4(0.0, 0.0, 0.0, 0.0);
					    return o;
					}

#endif

#if 1 && defined (DIRECTIONAL) && !defined (LIGHTPROBE_SH) && !defined (FADE_FROM_VERTEX_COLORS) && !defined (TRIPLANAR) && !defined (SHADOWS_SCREEN) && !defined (INSTANCING_ON)

					uniform float4 _TintColor;
					uniform float _ExternalAlpha;
					uniform float4 _CutoffScroll;
					uniform float _InvFade;
					uniform float _IntersectionStrength;
					uniform float _RimPower;
					uniform float _RimStrength;
					uniform float _SoftPower;
					uniform float _Boost;
					uniform float _AlphaBoost;
					uniform float4 unused_0_11[3];
					uniform  sampler2D _MainTex;
					uniform  sampler2D _Cloud1Tex;
					uniform  sampler2D _Cloud2Tex;
					uniform  sampler2D _CameraDepthTexture;
					uniform  sampler2D _RemapTex;
					struct target {
						float4 SV_Target0 : SV_Target0;
					};
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					target frag(inter i, bool isFrontFacing : SV_IsFrontFace)
					{
					    target o;
					float4 u_xlat0;
					float4 u_xlat1;
					float4 u_xlat2;
					float4 u_xlat3;
					float3 u_xlat4;
					float2 u_xlat5;
					bool u_xlatb5;
					    u_xlat0.x = ((isFrontFacing ? 0xffffffffu : uint(0)) != uint(0)) ? 1.0 : -1.0;
					    u_xlat4.xyz = (-i.vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat1.x = dot(u_xlat4.xyz, u_xlat4.xyz);
					    u_xlat1.x = rsqrt(u_xlat1.x);
					    u_xlat4.xyz = u_xlat4.xyz * u_xlat1.xxx;
					    u_xlat1 = tex2D(_MainTex, i.vs_TEXCOORD0.xy);
					    u_xlat1.x = u_xlat1.w * _TintColor.w;
					    u_xlat1.x = u_xlat1.x * i.vs_COLOR0.w;
					    u_xlat5.xy = _Time.xx * _CutoffScroll.xy + i.vs_TEXCOORD0.zw;
					    u_xlat2 = tex2D(_Cloud1Tex, u_xlat5.xy);
					    u_xlat5.xy = _Time.xx * _CutoffScroll.zw + i.vs_TEXCOORD1.xy;
					    u_xlat3 = tex2D(_Cloud2Tex, u_xlat5.xy);
					    u_xlat1.x = u_xlat1.x * u_xlat2.w;
					    u_xlat1.x = u_xlat3.w * u_xlat1.x;
					    u_xlat1.x = u_xlat1.x * 4.0;
					    u_xlat1.x = u_xlat1.x * _AlphaBoost;
					    u_xlat1.x = u_xlat1.x * _ExternalAlpha;
					    u_xlatb5 = 0.0<_InvFade;
					    if(u_xlatb5){
					        u_xlat5.xy = i.vs_TEXCOORD4.xy / i.vs_TEXCOORD4.ww;
					        u_xlat2 = tex2D(_CameraDepthTexture, u_xlat5.xy);
					        u_xlat5.x = _ZBufferParams.z * u_xlat2.x + _ZBufferParams.w;
					        u_xlat5.x = float(1.0) / u_xlat5.x;
					        u_xlat5.x = u_xlat5.x + (-i.vs_TEXCOORD4.w);
					        u_xlat5.x = u_xlat5.x * _InvFade;
					        u_xlat5.x = clamp(u_xlat5.x, 0.0, 1.0);
					        u_xlat5.x = log2(u_xlat5.x);
					        u_xlat5.x = u_xlat5.x * _SoftPower;
					        u_xlat5.x = exp2(u_xlat5.x);
					    } else {
					        u_xlat5.x = 1.0;
					    }
					    u_xlat4.x = dot(u_xlat4.xyz, i.vs_TEXCOORD2.xyz);
					    u_xlat0.x = u_xlat0.x * u_xlat4.x;
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					    u_xlat0.x = (-u_xlat0.x) + 1.0;
					    u_xlat0.x = log2(u_xlat0.x);
					    u_xlat0.x = u_xlat0.x * _RimPower;
					    u_xlat0.x = exp2(u_xlat0.x);
					    u_xlat0.x = u_xlat0.x * _RimStrength + (-u_xlat5.x);
					    u_xlat0.x = u_xlat0.x + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat1.x;
					    u_xlat0.x = u_xlat0.x * _IntersectionStrength;
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					    u_xlat0.y = 0.5;
					    u_xlat0 = tex2D(_RemapTex, u_xlat0.xy);
					    u_xlat0 = u_xlat0 * _TintColor;
					    o.SV_Target0.xyz = u_xlat0.xyz * float3(float3(_Boost, _Boost, _Boost));
					    o.SV_Target0.w = u_xlat0.w;
					    return o;
					}

#endif

#if 1 && defined (DIRECTIONAL) && defined (LIGHTPROBE_SH) && defined (FADE_FROM_VERTEX_COLORS) && !defined (TRIPLANAR) && !defined (SHADOWS_SCREEN) && !defined (INSTANCING_ON)

					uniform float4 _TintColor;
					uniform float _ExternalAlpha;
					uniform float4 _CutoffScroll;
					uniform float _InvFade;
					uniform float _IntersectionStrength;
					uniform float _RimPower;
					uniform float _RimStrength;
					uniform float _SoftPower;
					uniform float _Boost;
					uniform float _AlphaBoost;
					uniform float4 unused_0_11[3];
					uniform  sampler2D _MainTex;
					uniform  sampler2D _Cloud1Tex;
					uniform  sampler2D _Cloud2Tex;
					uniform  sampler2D _CameraDepthTexture;
					uniform  sampler2D _RemapTex;
					struct target {
						float4 SV_Target0 : SV_Target0;
					};
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					target frag(inter i, bool isFrontFacing : SV_IsFrontFace)
					{
					    target o;
					float4 u_xlat0;
					float4 u_xlat1;
					float4 u_xlat2;
					float4 u_xlat3;
					float3 u_xlat4;
					float2 u_xlat5;
					bool u_xlatb5;
					    u_xlat0.x = ((isFrontFacing ? 0xffffffffu : uint(0)) != uint(0)) ? 1.0 : -1.0;
					    u_xlat4.xyz = (-i.vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat1.x = dot(u_xlat4.xyz, u_xlat4.xyz);
					    u_xlat1.x = rsqrt(u_xlat1.x);
					    u_xlat4.xyz = u_xlat4.xyz * u_xlat1.xxx;
					    u_xlat1 = tex2D(_MainTex, i.vs_TEXCOORD0.xy);
					    u_xlat1.x = u_xlat1.w * _TintColor.w;
					    u_xlat1.x = u_xlat1.x * i.vs_COLOR0.w;
					    u_xlat5.xy = _Time.xx * _CutoffScroll.xy + i.vs_TEXCOORD0.zw;
					    u_xlat2 = tex2D(_Cloud1Tex, u_xlat5.xy);
					    u_xlat5.xy = _Time.xx * _CutoffScroll.zw + i.vs_TEXCOORD1.xy;
					    u_xlat3 = tex2D(_Cloud2Tex, u_xlat5.xy);
					    u_xlat1.x = u_xlat1.x * u_xlat2.w;
					    u_xlat1.x = u_xlat3.w * u_xlat1.x;
					    u_xlat1.x = u_xlat1.x * 4.0;
					    u_xlat1.x = u_xlat1.x * _AlphaBoost;
					    u_xlat1.x = u_xlat1.x * _ExternalAlpha;
					    u_xlatb5 = 0.0<_InvFade;
					    if(u_xlatb5){
					        u_xlat5.xy = i.vs_TEXCOORD4.xy / i.vs_TEXCOORD4.ww;
					        u_xlat2 = tex2D(_CameraDepthTexture, u_xlat5.xy);
					        u_xlat5.x = _ZBufferParams.z * u_xlat2.x + _ZBufferParams.w;
					        u_xlat5.x = float(1.0) / u_xlat5.x;
					        u_xlat5.x = u_xlat5.x + (-i.vs_TEXCOORD4.w);
					        u_xlat5.x = u_xlat5.x * _InvFade;
					        u_xlat5.x = clamp(u_xlat5.x, 0.0, 1.0);
					        u_xlat5.x = log2(u_xlat5.x);
					        u_xlat5.x = u_xlat5.x * _SoftPower;
					        u_xlat5.x = exp2(u_xlat5.x);
					    } else {
					        u_xlat5.x = 1.0;
					    }
					    u_xlat4.x = dot(u_xlat4.xyz, i.vs_TEXCOORD2.xyz);
					    u_xlat0.x = u_xlat0.x * u_xlat4.x;
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					    u_xlat0.x = (-u_xlat0.x) + 1.0;
					    u_xlat0.x = log2(u_xlat0.x);
					    u_xlat0.x = u_xlat0.x * _RimPower;
					    u_xlat0.x = exp2(u_xlat0.x);
					    u_xlat0.x = u_xlat0.x * _RimStrength + (-u_xlat5.x);
					    u_xlat0.x = u_xlat0.x + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat1.x;
					    u_xlat0.x = u_xlat0.x * _IntersectionStrength;
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					    u_xlat0.y = 0.5;
					    u_xlat0 = tex2D(_RemapTex, u_xlat0.xy);
					    u_xlat0 = u_xlat0 * _TintColor;
					    o.SV_Target0.w = u_xlat0.w * i.vs_COLOR0.x;
					    o.SV_Target0.xyz = u_xlat0.xyz * float3(float3(_Boost, _Boost, _Boost));
					    return o;
					}

#endif

#if 1 && defined (DIRECTIONAL) && defined (LIGHTPROBE_SH) && !defined (FADE_FROM_VERTEX_COLORS) && defined (TRIPLANAR) && !defined (SHADOWS_SCREEN) && !defined (INSTANCING_ON)

					uniform float4 _TintColor;
					uniform float _ExternalAlpha;
					uniform float4 _CutoffScroll;
					uniform float _InvFade;
					uniform float _IntersectionStrength;
					uniform float _RimPower;
					uniform float _RimStrength;
					uniform float _SoftPower;
					uniform float _Boost;
					uniform float _AlphaBoost;
					uniform float4 _Cloud1Tex_ST;
					uniform float4 _Cloud2Tex_ST;
					uniform float4 unused_0_13;
					uniform  sampler2D _MainTex;
					uniform  sampler2D _Cloud1Tex;
					uniform  sampler2D _Cloud2Tex;
					uniform  sampler2D _CameraDepthTexture;
					uniform  sampler2D _RemapTex;
					struct target {
						float4 SV_Target0 : SV_Target0;
					};
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					target frag(inter i, bool isFrontFacing : SV_IsFrontFace)
					{
					    target o;
					float4 u_xlat0;
					float4 u_xlat1;
					float4 u_xlat2;
					float4 u_xlat3;
					float4 u_xlat4;
					float4 u_xlat5;
					float4 u_xlat6;
					float4 u_xlat7;
					float3 u_xlat8;
					float3 u_xlat9;
					bool u_xlatb9;
					float u_xlat17;
					    u_xlat0.x = ((isFrontFacing ? 0xffffffffu : uint(0)) != uint(0)) ? 1.0 : -1.0;
					    u_xlat8.xyz = (-i.vs_TEXCOORD2.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat1.x = dot(u_xlat8.xyz, u_xlat8.xyz);
					    u_xlat1.x = rsqrt(u_xlat1.x);
					    u_xlat8.xyz = u_xlat8.xyz * u_xlat1.xxx;
					    u_xlat1 = tex2D(_MainTex, i.vs_TEXCOORD0.xy);
					    u_xlat1.x = u_xlat1.w * _TintColor.w;
					    u_xlat1.x = u_xlat1.x * i.vs_COLOR0.w;
					    u_xlat9.x = abs(i.vs_TEXCOORD1.y) + abs(i.vs_TEXCOORD1.x);
					    u_xlat9.x = u_xlat9.x + abs(i.vs_TEXCOORD1.z);
					    u_xlat9.xyz = abs(i.vs_TEXCOORD1.xyz) / u_xlat9.xxx;
					    u_xlat2 = _Time.xxxx * _CutoffScroll.xyxy + i.vs_TEXCOORD2.zyxz;
					    u_xlat2 = u_xlat2 * _Cloud1Tex_ST.xyxy;
					    u_xlat3 = tex2D(_Cloud1Tex, u_xlat2.xy);
					    u_xlat2 = tex2D(_Cloud1Tex, u_xlat2.zw);
					    u_xlat4 = _Time.xxxx * _CutoffScroll + i.vs_TEXCOORD2.xyzy;
					    u_xlat2.xy = u_xlat4.xy * _Cloud1Tex_ST.xy;
					    u_xlat5 = tex2D(_Cloud1Tex, u_xlat2.xy);
					    u_xlat2.xy = u_xlat4.zw * _Cloud2Tex_ST.xy;
					    u_xlat4 = tex2D(_Cloud2Tex, u_xlat2.xy);
					    u_xlat6 = _Time.xxxx * _CutoffScroll.zwzw + i.vs_TEXCOORD2.xzxy;
					    u_xlat6 = u_xlat6 * _Cloud2Tex_ST.xyxy;
					    u_xlat7 = tex2D(_Cloud2Tex, u_xlat6.xy);
					    u_xlat6 = tex2D(_Cloud2Tex, u_xlat6.zw);
					    u_xlat2.x = u_xlat9.y * u_xlat2.w;
					    u_xlat2.x = u_xlat9.x * u_xlat3.w + u_xlat2.x;
					    u_xlat2.x = u_xlat9.z * u_xlat5.w + u_xlat2.x;
					    u_xlat17 = u_xlat9.y * u_xlat7.w;
					    u_xlat9.x = u_xlat9.x * u_xlat4.w + u_xlat17;
					    u_xlat9.x = u_xlat9.z * u_xlat6.w + u_xlat9.x;
					    u_xlat1.x = u_xlat1.x * u_xlat2.x;
					    u_xlat1.x = u_xlat9.x * u_xlat1.x;
					    u_xlat1.x = u_xlat1.x * 4.0;
					    u_xlat1.x = u_xlat1.x * _AlphaBoost;
					    u_xlat1.x = u_xlat1.x * _ExternalAlpha;
					    u_xlatb9 = 0.0<_InvFade;
					    if(u_xlatb9){
					        u_xlat9.xy = i.vs_TEXCOORD3.xy / i.vs_TEXCOORD3.ww;
					        u_xlat2 = tex2D(_CameraDepthTexture, u_xlat9.xy);
					        u_xlat9.x = _ZBufferParams.z * u_xlat2.x + _ZBufferParams.w;
					        u_xlat9.x = float(1.0) / u_xlat9.x;
					        u_xlat9.x = u_xlat9.x + (-i.vs_TEXCOORD3.w);
					        u_xlat9.x = u_xlat9.x * _InvFade;
					        u_xlat9.x = clamp(u_xlat9.x, 0.0, 1.0);
					        u_xlat9.x = log2(u_xlat9.x);
					        u_xlat9.x = u_xlat9.x * _SoftPower;
					        u_xlat9.x = exp2(u_xlat9.x);
					    } else {
					        u_xlat9.x = 1.0;
					    }
					    u_xlat8.x = dot(u_xlat8.xyz, i.vs_TEXCOORD1.xyz);
					    u_xlat0.x = u_xlat0.x * u_xlat8.x;
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					    u_xlat0.x = (-u_xlat0.x) + 1.0;
					    u_xlat0.x = log2(u_xlat0.x);
					    u_xlat0.x = u_xlat0.x * _RimPower;
					    u_xlat0.x = exp2(u_xlat0.x);
					    u_xlat0.x = u_xlat0.x * _RimStrength + (-u_xlat9.x);
					    u_xlat0.x = u_xlat0.x + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat1.x;
					    u_xlat0.x = u_xlat0.x * _IntersectionStrength;
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					    u_xlat0.y = 0.5;
					    u_xlat0 = tex2D(_RemapTex, u_xlat0.xy);
					    u_xlat0 = u_xlat0 * _TintColor;
					    o.SV_Target0.xyz = u_xlat0.xyz * float3(float3(_Boost, _Boost, _Boost));
					    o.SV_Target0.w = u_xlat0.w;
					    return o;
					}

#endif

#if 1 && defined (DIRECTIONAL) && defined (LIGHTPROBE_SH) && !defined (FADE_FROM_VERTEX_COLORS) && !defined (TRIPLANAR) && !defined (SHADOWS_SCREEN) && !defined (INSTANCING_ON)

					uniform float4 _TintColor;
					uniform float _ExternalAlpha;
					uniform float4 _CutoffScroll;
					uniform float _InvFade;
					uniform float _IntersectionStrength;
					uniform float _RimPower;
					uniform float _RimStrength;
					uniform float _SoftPower;
					uniform float _Boost;
					uniform float _AlphaBoost;
					uniform float4 unused_0_11[3];
					uniform  sampler2D _MainTex;
					uniform  sampler2D _Cloud1Tex;
					uniform  sampler2D _Cloud2Tex;
					uniform  sampler2D _CameraDepthTexture;
					uniform  sampler2D _RemapTex;
					struct target {
						float4 SV_Target0 : SV_Target0;
					};
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					target frag(inter i, bool isFrontFacing : SV_IsFrontFace)
					{
					    target o;
					float4 u_xlat0;
					float4 u_xlat1;
					float4 u_xlat2;
					float4 u_xlat3;
					float3 u_xlat4;
					float2 u_xlat5;
					bool u_xlatb5;
					    u_xlat0.x = ((isFrontFacing ? 0xffffffffu : uint(0)) != uint(0)) ? 1.0 : -1.0;
					    u_xlat4.xyz = (-i.vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat1.x = dot(u_xlat4.xyz, u_xlat4.xyz);
					    u_xlat1.x = rsqrt(u_xlat1.x);
					    u_xlat4.xyz = u_xlat4.xyz * u_xlat1.xxx;
					    u_xlat1 = tex2D(_MainTex, i.vs_TEXCOORD0.xy);
					    u_xlat1.x = u_xlat1.w * _TintColor.w;
					    u_xlat1.x = u_xlat1.x * i.vs_COLOR0.w;
					    u_xlat5.xy = _Time.xx * _CutoffScroll.xy + i.vs_TEXCOORD0.zw;
					    u_xlat2 = tex2D(_Cloud1Tex, u_xlat5.xy);
					    u_xlat5.xy = _Time.xx * _CutoffScroll.zw + i.vs_TEXCOORD1.xy;
					    u_xlat3 = tex2D(_Cloud2Tex, u_xlat5.xy);
					    u_xlat1.x = u_xlat1.x * u_xlat2.w;
					    u_xlat1.x = u_xlat3.w * u_xlat1.x;
					    u_xlat1.x = u_xlat1.x * 4.0;
					    u_xlat1.x = u_xlat1.x * _AlphaBoost;
					    u_xlat1.x = u_xlat1.x * _ExternalAlpha;
					    u_xlatb5 = 0.0<_InvFade;
					    if(u_xlatb5){
					        u_xlat5.xy = i.vs_TEXCOORD4.xy / i.vs_TEXCOORD4.ww;
					        u_xlat2 = tex2D(_CameraDepthTexture, u_xlat5.xy);
					        u_xlat5.x = _ZBufferParams.z * u_xlat2.x + _ZBufferParams.w;
					        u_xlat5.x = float(1.0) / u_xlat5.x;
					        u_xlat5.x = u_xlat5.x + (-i.vs_TEXCOORD4.w);
					        u_xlat5.x = u_xlat5.x * _InvFade;
					        u_xlat5.x = clamp(u_xlat5.x, 0.0, 1.0);
					        u_xlat5.x = log2(u_xlat5.x);
					        u_xlat5.x = u_xlat5.x * _SoftPower;
					        u_xlat5.x = exp2(u_xlat5.x);
					    } else {
					        u_xlat5.x = 1.0;
					    }
					    u_xlat4.x = dot(u_xlat4.xyz, i.vs_TEXCOORD2.xyz);
					    u_xlat0.x = u_xlat0.x * u_xlat4.x;
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					    u_xlat0.x = (-u_xlat0.x) + 1.0;
					    u_xlat0.x = log2(u_xlat0.x);
					    u_xlat0.x = u_xlat0.x * _RimPower;
					    u_xlat0.x = exp2(u_xlat0.x);
					    u_xlat0.x = u_xlat0.x * _RimStrength + (-u_xlat5.x);
					    u_xlat0.x = u_xlat0.x + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat1.x;
					    u_xlat0.x = u_xlat0.x * _IntersectionStrength;
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					    u_xlat0.y = 0.5;
					    u_xlat0 = tex2D(_RemapTex, u_xlat0.xy);
					    u_xlat0 = u_xlat0 * _TintColor;
					    o.SV_Target0.xyz = u_xlat0.xyz * float3(float3(_Boost, _Boost, _Boost));
					    o.SV_Target0.w = u_xlat0.w;
					    return o;
					}

#endif

#if 1 && defined (DIRECTIONAL) && !defined (LIGHTPROBE_SH) && defined (FADE_FROM_VERTEX_COLORS) && !defined (TRIPLANAR) && defined (SHADOWS_SCREEN) && !defined (INSTANCING_ON)

					uniform float4 _TintColor;
					uniform float _ExternalAlpha;
					uniform float4 _CutoffScroll;
					uniform float _InvFade;
					uniform float _IntersectionStrength;
					uniform float _RimPower;
					uniform float _RimStrength;
					uniform float _SoftPower;
					uniform float _Boost;
					uniform float _AlphaBoost;
					uniform float4 unused_0_11[3];
					uniform  sampler2D _MainTex;
					uniform  sampler2D _Cloud1Tex;
					uniform  sampler2D _Cloud2Tex;
					uniform  sampler2D _CameraDepthTexture;
					uniform  sampler2D _RemapTex;
					struct target {
						float4 SV_Target0 : SV_Target0;
					};
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					target frag(inter i, bool isFrontFacing : SV_IsFrontFace)
					{
					    target o;
					float4 u_xlat0;
					float4 u_xlat1;
					float4 u_xlat2;
					float4 u_xlat3;
					float3 u_xlat4;
					float2 u_xlat5;
					bool u_xlatb5;
					    u_xlat0.x = ((isFrontFacing ? 0xffffffffu : uint(0)) != uint(0)) ? 1.0 : -1.0;
					    u_xlat4.xyz = (-i.vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat1.x = dot(u_xlat4.xyz, u_xlat4.xyz);
					    u_xlat1.x = rsqrt(u_xlat1.x);
					    u_xlat4.xyz = u_xlat4.xyz * u_xlat1.xxx;
					    u_xlat1 = tex2D(_MainTex, i.vs_TEXCOORD0.xy);
					    u_xlat1.x = u_xlat1.w * _TintColor.w;
					    u_xlat1.x = u_xlat1.x * i.vs_COLOR0.w;
					    u_xlat5.xy = _Time.xx * _CutoffScroll.xy + i.vs_TEXCOORD0.zw;
					    u_xlat2 = tex2D(_Cloud1Tex, u_xlat5.xy);
					    u_xlat5.xy = _Time.xx * _CutoffScroll.zw + i.vs_TEXCOORD1.xy;
					    u_xlat3 = tex2D(_Cloud2Tex, u_xlat5.xy);
					    u_xlat1.x = u_xlat1.x * u_xlat2.w;
					    u_xlat1.x = u_xlat3.w * u_xlat1.x;
					    u_xlat1.x = u_xlat1.x * 4.0;
					    u_xlat1.x = u_xlat1.x * _AlphaBoost;
					    u_xlat1.x = u_xlat1.x * _ExternalAlpha;
					    u_xlatb5 = 0.0<_InvFade;
					    if(u_xlatb5){
					        u_xlat5.xy = i.vs_TEXCOORD4.xy / i.vs_TEXCOORD4.ww;
					        u_xlat2 = tex2D(_CameraDepthTexture, u_xlat5.xy);
					        u_xlat5.x = _ZBufferParams.z * u_xlat2.x + _ZBufferParams.w;
					        u_xlat5.x = float(1.0) / u_xlat5.x;
					        u_xlat5.x = u_xlat5.x + (-i.vs_TEXCOORD4.w);
					        u_xlat5.x = u_xlat5.x * _InvFade;
					        u_xlat5.x = clamp(u_xlat5.x, 0.0, 1.0);
					        u_xlat5.x = log2(u_xlat5.x);
					        u_xlat5.x = u_xlat5.x * _SoftPower;
					        u_xlat5.x = exp2(u_xlat5.x);
					    } else {
					        u_xlat5.x = 1.0;
					    }
					    u_xlat4.x = dot(u_xlat4.xyz, i.vs_TEXCOORD2.xyz);
					    u_xlat0.x = u_xlat0.x * u_xlat4.x;
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					    u_xlat0.x = (-u_xlat0.x) + 1.0;
					    u_xlat0.x = log2(u_xlat0.x);
					    u_xlat0.x = u_xlat0.x * _RimPower;
					    u_xlat0.x = exp2(u_xlat0.x);
					    u_xlat0.x = u_xlat0.x * _RimStrength + (-u_xlat5.x);
					    u_xlat0.x = u_xlat0.x + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat1.x;
					    u_xlat0.x = u_xlat0.x * _IntersectionStrength;
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					    u_xlat0.y = 0.5;
					    u_xlat0 = tex2D(_RemapTex, u_xlat0.xy);
					    u_xlat0 = u_xlat0 * _TintColor;
					    o.SV_Target0.w = u_xlat0.w * i.vs_COLOR0.x;
					    o.SV_Target0.xyz = u_xlat0.xyz * float3(float3(_Boost, _Boost, _Boost));
					    return o;
					}

#endif

#if 1 && defined (DIRECTIONAL) && !defined (LIGHTPROBE_SH) && !defined (FADE_FROM_VERTEX_COLORS) && defined (TRIPLANAR) && defined (SHADOWS_SCREEN) && !defined (INSTANCING_ON)

					uniform float4 _TintColor;
					uniform float _ExternalAlpha;
					uniform float4 _CutoffScroll;
					uniform float _InvFade;
					uniform float _IntersectionStrength;
					uniform float _RimPower;
					uniform float _RimStrength;
					uniform float _SoftPower;
					uniform float _Boost;
					uniform float _AlphaBoost;
					uniform float4 _Cloud1Tex_ST;
					uniform float4 _Cloud2Tex_ST;
					uniform float4 unused_0_13;
					uniform  sampler2D _MainTex;
					uniform  sampler2D _Cloud1Tex;
					uniform  sampler2D _Cloud2Tex;
					uniform  sampler2D _CameraDepthTexture;
					uniform  sampler2D _RemapTex;
					struct target {
						float4 SV_Target0 : SV_Target0;
					};
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					target frag(inter i, bool isFrontFacing : SV_IsFrontFace)
					{
					    target o;
					float4 u_xlat0;
					float4 u_xlat1;
					float4 u_xlat2;
					float4 u_xlat3;
					float4 u_xlat4;
					float4 u_xlat5;
					float4 u_xlat6;
					float4 u_xlat7;
					float3 u_xlat8;
					float3 u_xlat9;
					bool u_xlatb9;
					float u_xlat17;
					    u_xlat0.x = ((isFrontFacing ? 0xffffffffu : uint(0)) != uint(0)) ? 1.0 : -1.0;
					    u_xlat8.xyz = (-i.vs_TEXCOORD2.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat1.x = dot(u_xlat8.xyz, u_xlat8.xyz);
					    u_xlat1.x = rsqrt(u_xlat1.x);
					    u_xlat8.xyz = u_xlat8.xyz * u_xlat1.xxx;
					    u_xlat1 = tex2D(_MainTex, i.vs_TEXCOORD0.xy);
					    u_xlat1.x = u_xlat1.w * _TintColor.w;
					    u_xlat1.x = u_xlat1.x * i.vs_COLOR0.w;
					    u_xlat9.x = abs(i.vs_TEXCOORD1.y) + abs(i.vs_TEXCOORD1.x);
					    u_xlat9.x = u_xlat9.x + abs(i.vs_TEXCOORD1.z);
					    u_xlat9.xyz = abs(i.vs_TEXCOORD1.xyz) / u_xlat9.xxx;
					    u_xlat2 = _Time.xxxx * _CutoffScroll.xyxy + i.vs_TEXCOORD2.zyxz;
					    u_xlat2 = u_xlat2 * _Cloud1Tex_ST.xyxy;
					    u_xlat3 = tex2D(_Cloud1Tex, u_xlat2.xy);
					    u_xlat2 = tex2D(_Cloud1Tex, u_xlat2.zw);
					    u_xlat4 = _Time.xxxx * _CutoffScroll + i.vs_TEXCOORD2.xyzy;
					    u_xlat2.xy = u_xlat4.xy * _Cloud1Tex_ST.xy;
					    u_xlat5 = tex2D(_Cloud1Tex, u_xlat2.xy);
					    u_xlat2.xy = u_xlat4.zw * _Cloud2Tex_ST.xy;
					    u_xlat4 = tex2D(_Cloud2Tex, u_xlat2.xy);
					    u_xlat6 = _Time.xxxx * _CutoffScroll.zwzw + i.vs_TEXCOORD2.xzxy;
					    u_xlat6 = u_xlat6 * _Cloud2Tex_ST.xyxy;
					    u_xlat7 = tex2D(_Cloud2Tex, u_xlat6.xy);
					    u_xlat6 = tex2D(_Cloud2Tex, u_xlat6.zw);
					    u_xlat2.x = u_xlat9.y * u_xlat2.w;
					    u_xlat2.x = u_xlat9.x * u_xlat3.w + u_xlat2.x;
					    u_xlat2.x = u_xlat9.z * u_xlat5.w + u_xlat2.x;
					    u_xlat17 = u_xlat9.y * u_xlat7.w;
					    u_xlat9.x = u_xlat9.x * u_xlat4.w + u_xlat17;
					    u_xlat9.x = u_xlat9.z * u_xlat6.w + u_xlat9.x;
					    u_xlat1.x = u_xlat1.x * u_xlat2.x;
					    u_xlat1.x = u_xlat9.x * u_xlat1.x;
					    u_xlat1.x = u_xlat1.x * 4.0;
					    u_xlat1.x = u_xlat1.x * _AlphaBoost;
					    u_xlat1.x = u_xlat1.x * _ExternalAlpha;
					    u_xlatb9 = 0.0<_InvFade;
					    if(u_xlatb9){
					        u_xlat9.xy = i.vs_TEXCOORD3.xy / i.vs_TEXCOORD3.ww;
					        u_xlat2 = tex2D(_CameraDepthTexture, u_xlat9.xy);
					        u_xlat9.x = _ZBufferParams.z * u_xlat2.x + _ZBufferParams.w;
					        u_xlat9.x = float(1.0) / u_xlat9.x;
					        u_xlat9.x = u_xlat9.x + (-i.vs_TEXCOORD3.w);
					        u_xlat9.x = u_xlat9.x * _InvFade;
					        u_xlat9.x = clamp(u_xlat9.x, 0.0, 1.0);
					        u_xlat9.x = log2(u_xlat9.x);
					        u_xlat9.x = u_xlat9.x * _SoftPower;
					        u_xlat9.x = exp2(u_xlat9.x);
					    } else {
					        u_xlat9.x = 1.0;
					    }
					    u_xlat8.x = dot(u_xlat8.xyz, i.vs_TEXCOORD1.xyz);
					    u_xlat0.x = u_xlat0.x * u_xlat8.x;
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					    u_xlat0.x = (-u_xlat0.x) + 1.0;
					    u_xlat0.x = log2(u_xlat0.x);
					    u_xlat0.x = u_xlat0.x * _RimPower;
					    u_xlat0.x = exp2(u_xlat0.x);
					    u_xlat0.x = u_xlat0.x * _RimStrength + (-u_xlat9.x);
					    u_xlat0.x = u_xlat0.x + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat1.x;
					    u_xlat0.x = u_xlat0.x * _IntersectionStrength;
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					    u_xlat0.y = 0.5;
					    u_xlat0 = tex2D(_RemapTex, u_xlat0.xy);
					    u_xlat0 = u_xlat0 * _TintColor;
					    o.SV_Target0.xyz = u_xlat0.xyz * float3(float3(_Boost, _Boost, _Boost));
					    o.SV_Target0.w = u_xlat0.w;
					    return o;
					}

#endif

#if 1 && defined (DIRECTIONAL) && !defined (LIGHTPROBE_SH) && !defined (FADE_FROM_VERTEX_COLORS) && !defined (TRIPLANAR) && defined (SHADOWS_SCREEN) && !defined (INSTANCING_ON)

					uniform float4 _TintColor;
					uniform float _ExternalAlpha;
					uniform float4 _CutoffScroll;
					uniform float _InvFade;
					uniform float _IntersectionStrength;
					uniform float _RimPower;
					uniform float _RimStrength;
					uniform float _SoftPower;
					uniform float _Boost;
					uniform float _AlphaBoost;
					uniform float4 unused_0_11[3];
					uniform  sampler2D _MainTex;
					uniform  sampler2D _Cloud1Tex;
					uniform  sampler2D _Cloud2Tex;
					uniform  sampler2D _CameraDepthTexture;
					uniform  sampler2D _RemapTex;
					struct target {
						float4 SV_Target0 : SV_Target0;
					};
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					target frag(inter i, bool isFrontFacing : SV_IsFrontFace)
					{
					    target o;
					float4 u_xlat0;
					float4 u_xlat1;
					float4 u_xlat2;
					float4 u_xlat3;
					float3 u_xlat4;
					float2 u_xlat5;
					bool u_xlatb5;
					    u_xlat0.x = ((isFrontFacing ? 0xffffffffu : uint(0)) != uint(0)) ? 1.0 : -1.0;
					    u_xlat4.xyz = (-i.vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat1.x = dot(u_xlat4.xyz, u_xlat4.xyz);
					    u_xlat1.x = rsqrt(u_xlat1.x);
					    u_xlat4.xyz = u_xlat4.xyz * u_xlat1.xxx;
					    u_xlat1 = tex2D(_MainTex, i.vs_TEXCOORD0.xy);
					    u_xlat1.x = u_xlat1.w * _TintColor.w;
					    u_xlat1.x = u_xlat1.x * i.vs_COLOR0.w;
					    u_xlat5.xy = _Time.xx * _CutoffScroll.xy + i.vs_TEXCOORD0.zw;
					    u_xlat2 = tex2D(_Cloud1Tex, u_xlat5.xy);
					    u_xlat5.xy = _Time.xx * _CutoffScroll.zw + i.vs_TEXCOORD1.xy;
					    u_xlat3 = tex2D(_Cloud2Tex, u_xlat5.xy);
					    u_xlat1.x = u_xlat1.x * u_xlat2.w;
					    u_xlat1.x = u_xlat3.w * u_xlat1.x;
					    u_xlat1.x = u_xlat1.x * 4.0;
					    u_xlat1.x = u_xlat1.x * _AlphaBoost;
					    u_xlat1.x = u_xlat1.x * _ExternalAlpha;
					    u_xlatb5 = 0.0<_InvFade;
					    if(u_xlatb5){
					        u_xlat5.xy = i.vs_TEXCOORD4.xy / i.vs_TEXCOORD4.ww;
					        u_xlat2 = tex2D(_CameraDepthTexture, u_xlat5.xy);
					        u_xlat5.x = _ZBufferParams.z * u_xlat2.x + _ZBufferParams.w;
					        u_xlat5.x = float(1.0) / u_xlat5.x;
					        u_xlat5.x = u_xlat5.x + (-i.vs_TEXCOORD4.w);
					        u_xlat5.x = u_xlat5.x * _InvFade;
					        u_xlat5.x = clamp(u_xlat5.x, 0.0, 1.0);
					        u_xlat5.x = log2(u_xlat5.x);
					        u_xlat5.x = u_xlat5.x * _SoftPower;
					        u_xlat5.x = exp2(u_xlat5.x);
					    } else {
					        u_xlat5.x = 1.0;
					    }
					    u_xlat4.x = dot(u_xlat4.xyz, i.vs_TEXCOORD2.xyz);
					    u_xlat0.x = u_xlat0.x * u_xlat4.x;
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					    u_xlat0.x = (-u_xlat0.x) + 1.0;
					    u_xlat0.x = log2(u_xlat0.x);
					    u_xlat0.x = u_xlat0.x * _RimPower;
					    u_xlat0.x = exp2(u_xlat0.x);
					    u_xlat0.x = u_xlat0.x * _RimStrength + (-u_xlat5.x);
					    u_xlat0.x = u_xlat0.x + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat1.x;
					    u_xlat0.x = u_xlat0.x * _IntersectionStrength;
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					    u_xlat0.y = 0.5;
					    u_xlat0 = tex2D(_RemapTex, u_xlat0.xy);
					    u_xlat0 = u_xlat0 * _TintColor;
					    o.SV_Target0.xyz = u_xlat0.xyz * float3(float3(_Boost, _Boost, _Boost));
					    o.SV_Target0.w = u_xlat0.w;
					    return o;
					}

#endif

#if 1 && defined (DIRECTIONAL) && defined (LIGHTPROBE_SH) && defined (FADE_FROM_VERTEX_COLORS) && !defined (TRIPLANAR) && defined (SHADOWS_SCREEN) && !defined (INSTANCING_ON)

					uniform float4 _TintColor;
					uniform float _ExternalAlpha;
					uniform float4 _CutoffScroll;
					uniform float _InvFade;
					uniform float _IntersectionStrength;
					uniform float _RimPower;
					uniform float _RimStrength;
					uniform float _SoftPower;
					uniform float _Boost;
					uniform float _AlphaBoost;
					uniform float4 unused_0_11[3];
					uniform  sampler2D _MainTex;
					uniform  sampler2D _Cloud1Tex;
					uniform  sampler2D _Cloud2Tex;
					uniform  sampler2D _CameraDepthTexture;
					uniform  sampler2D _RemapTex;
					struct target {
						float4 SV_Target0 : SV_Target0;
					};
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					target frag(inter i, bool isFrontFacing : SV_IsFrontFace)
					{
					    target o;
					float4 u_xlat0;
					float4 u_xlat1;
					float4 u_xlat2;
					float4 u_xlat3;
					float3 u_xlat4;
					float2 u_xlat5;
					bool u_xlatb5;
					    u_xlat0.x = ((isFrontFacing ? 0xffffffffu : uint(0)) != uint(0)) ? 1.0 : -1.0;
					    u_xlat4.xyz = (-i.vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat1.x = dot(u_xlat4.xyz, u_xlat4.xyz);
					    u_xlat1.x = rsqrt(u_xlat1.x);
					    u_xlat4.xyz = u_xlat4.xyz * u_xlat1.xxx;
					    u_xlat1 = tex2D(_MainTex, i.vs_TEXCOORD0.xy);
					    u_xlat1.x = u_xlat1.w * _TintColor.w;
					    u_xlat1.x = u_xlat1.x * i.vs_COLOR0.w;
					    u_xlat5.xy = _Time.xx * _CutoffScroll.xy + i.vs_TEXCOORD0.zw;
					    u_xlat2 = tex2D(_Cloud1Tex, u_xlat5.xy);
					    u_xlat5.xy = _Time.xx * _CutoffScroll.zw + i.vs_TEXCOORD1.xy;
					    u_xlat3 = tex2D(_Cloud2Tex, u_xlat5.xy);
					    u_xlat1.x = u_xlat1.x * u_xlat2.w;
					    u_xlat1.x = u_xlat3.w * u_xlat1.x;
					    u_xlat1.x = u_xlat1.x * 4.0;
					    u_xlat1.x = u_xlat1.x * _AlphaBoost;
					    u_xlat1.x = u_xlat1.x * _ExternalAlpha;
					    u_xlatb5 = 0.0<_InvFade;
					    if(u_xlatb5){
					        u_xlat5.xy = i.vs_TEXCOORD4.xy / i.vs_TEXCOORD4.ww;
					        u_xlat2 = tex2D(_CameraDepthTexture, u_xlat5.xy);
					        u_xlat5.x = _ZBufferParams.z * u_xlat2.x + _ZBufferParams.w;
					        u_xlat5.x = float(1.0) / u_xlat5.x;
					        u_xlat5.x = u_xlat5.x + (-i.vs_TEXCOORD4.w);
					        u_xlat5.x = u_xlat5.x * _InvFade;
					        u_xlat5.x = clamp(u_xlat5.x, 0.0, 1.0);
					        u_xlat5.x = log2(u_xlat5.x);
					        u_xlat5.x = u_xlat5.x * _SoftPower;
					        u_xlat5.x = exp2(u_xlat5.x);
					    } else {
					        u_xlat5.x = 1.0;
					    }
					    u_xlat4.x = dot(u_xlat4.xyz, i.vs_TEXCOORD2.xyz);
					    u_xlat0.x = u_xlat0.x * u_xlat4.x;
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					    u_xlat0.x = (-u_xlat0.x) + 1.0;
					    u_xlat0.x = log2(u_xlat0.x);
					    u_xlat0.x = u_xlat0.x * _RimPower;
					    u_xlat0.x = exp2(u_xlat0.x);
					    u_xlat0.x = u_xlat0.x * _RimStrength + (-u_xlat5.x);
					    u_xlat0.x = u_xlat0.x + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat1.x;
					    u_xlat0.x = u_xlat0.x * _IntersectionStrength;
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					    u_xlat0.y = 0.5;
					    u_xlat0 = tex2D(_RemapTex, u_xlat0.xy);
					    u_xlat0 = u_xlat0 * _TintColor;
					    o.SV_Target0.w = u_xlat0.w * i.vs_COLOR0.x;
					    o.SV_Target0.xyz = u_xlat0.xyz * float3(float3(_Boost, _Boost, _Boost));
					    return o;
					}

#endif

#if 1 && defined (DIRECTIONAL) && defined (LIGHTPROBE_SH) && !defined (FADE_FROM_VERTEX_COLORS) && defined (TRIPLANAR) && defined (SHADOWS_SCREEN) && !defined (INSTANCING_ON)

					uniform float4 _TintColor;
					uniform float _ExternalAlpha;
					uniform float4 _CutoffScroll;
					uniform float _InvFade;
					uniform float _IntersectionStrength;
					uniform float _RimPower;
					uniform float _RimStrength;
					uniform float _SoftPower;
					uniform float _Boost;
					uniform float _AlphaBoost;
					uniform float4 _Cloud1Tex_ST;
					uniform float4 _Cloud2Tex_ST;
					uniform float4 unused_0_13;
					uniform  sampler2D _MainTex;
					uniform  sampler2D _Cloud1Tex;
					uniform  sampler2D _Cloud2Tex;
					uniform  sampler2D _CameraDepthTexture;
					uniform  sampler2D _RemapTex;
					struct target {
						float4 SV_Target0 : SV_Target0;
					};
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					target frag(inter i, bool isFrontFacing : SV_IsFrontFace)
					{
					    target o;
					float4 u_xlat0;
					float4 u_xlat1;
					float4 u_xlat2;
					float4 u_xlat3;
					float4 u_xlat4;
					float4 u_xlat5;
					float4 u_xlat6;
					float4 u_xlat7;
					float3 u_xlat8;
					float3 u_xlat9;
					bool u_xlatb9;
					float u_xlat17;
					    u_xlat0.x = ((isFrontFacing ? 0xffffffffu : uint(0)) != uint(0)) ? 1.0 : -1.0;
					    u_xlat8.xyz = (-i.vs_TEXCOORD2.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat1.x = dot(u_xlat8.xyz, u_xlat8.xyz);
					    u_xlat1.x = rsqrt(u_xlat1.x);
					    u_xlat8.xyz = u_xlat8.xyz * u_xlat1.xxx;
					    u_xlat1 = tex2D(_MainTex, i.vs_TEXCOORD0.xy);
					    u_xlat1.x = u_xlat1.w * _TintColor.w;
					    u_xlat1.x = u_xlat1.x * i.vs_COLOR0.w;
					    u_xlat9.x = abs(i.vs_TEXCOORD1.y) + abs(i.vs_TEXCOORD1.x);
					    u_xlat9.x = u_xlat9.x + abs(i.vs_TEXCOORD1.z);
					    u_xlat9.xyz = abs(i.vs_TEXCOORD1.xyz) / u_xlat9.xxx;
					    u_xlat2 = _Time.xxxx * _CutoffScroll.xyxy + i.vs_TEXCOORD2.zyxz;
					    u_xlat2 = u_xlat2 * _Cloud1Tex_ST.xyxy;
					    u_xlat3 = tex2D(_Cloud1Tex, u_xlat2.xy);
					    u_xlat2 = tex2D(_Cloud1Tex, u_xlat2.zw);
					    u_xlat4 = _Time.xxxx * _CutoffScroll + i.vs_TEXCOORD2.xyzy;
					    u_xlat2.xy = u_xlat4.xy * _Cloud1Tex_ST.xy;
					    u_xlat5 = tex2D(_Cloud1Tex, u_xlat2.xy);
					    u_xlat2.xy = u_xlat4.zw * _Cloud2Tex_ST.xy;
					    u_xlat4 = tex2D(_Cloud2Tex, u_xlat2.xy);
					    u_xlat6 = _Time.xxxx * _CutoffScroll.zwzw + i.vs_TEXCOORD2.xzxy;
					    u_xlat6 = u_xlat6 * _Cloud2Tex_ST.xyxy;
					    u_xlat7 = tex2D(_Cloud2Tex, u_xlat6.xy);
					    u_xlat6 = tex2D(_Cloud2Tex, u_xlat6.zw);
					    u_xlat2.x = u_xlat9.y * u_xlat2.w;
					    u_xlat2.x = u_xlat9.x * u_xlat3.w + u_xlat2.x;
					    u_xlat2.x = u_xlat9.z * u_xlat5.w + u_xlat2.x;
					    u_xlat17 = u_xlat9.y * u_xlat7.w;
					    u_xlat9.x = u_xlat9.x * u_xlat4.w + u_xlat17;
					    u_xlat9.x = u_xlat9.z * u_xlat6.w + u_xlat9.x;
					    u_xlat1.x = u_xlat1.x * u_xlat2.x;
					    u_xlat1.x = u_xlat9.x * u_xlat1.x;
					    u_xlat1.x = u_xlat1.x * 4.0;
					    u_xlat1.x = u_xlat1.x * _AlphaBoost;
					    u_xlat1.x = u_xlat1.x * _ExternalAlpha;
					    u_xlatb9 = 0.0<_InvFade;
					    if(u_xlatb9){
					        u_xlat9.xy = i.vs_TEXCOORD3.xy / i.vs_TEXCOORD3.ww;
					        u_xlat2 = tex2D(_CameraDepthTexture, u_xlat9.xy);
					        u_xlat9.x = _ZBufferParams.z * u_xlat2.x + _ZBufferParams.w;
					        u_xlat9.x = float(1.0) / u_xlat9.x;
					        u_xlat9.x = u_xlat9.x + (-i.vs_TEXCOORD3.w);
					        u_xlat9.x = u_xlat9.x * _InvFade;
					        u_xlat9.x = clamp(u_xlat9.x, 0.0, 1.0);
					        u_xlat9.x = log2(u_xlat9.x);
					        u_xlat9.x = u_xlat9.x * _SoftPower;
					        u_xlat9.x = exp2(u_xlat9.x);
					    } else {
					        u_xlat9.x = 1.0;
					    }
					    u_xlat8.x = dot(u_xlat8.xyz, i.vs_TEXCOORD1.xyz);
					    u_xlat0.x = u_xlat0.x * u_xlat8.x;
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					    u_xlat0.x = (-u_xlat0.x) + 1.0;
					    u_xlat0.x = log2(u_xlat0.x);
					    u_xlat0.x = u_xlat0.x * _RimPower;
					    u_xlat0.x = exp2(u_xlat0.x);
					    u_xlat0.x = u_xlat0.x * _RimStrength + (-u_xlat9.x);
					    u_xlat0.x = u_xlat0.x + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat1.x;
					    u_xlat0.x = u_xlat0.x * _IntersectionStrength;
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					    u_xlat0.y = 0.5;
					    u_xlat0 = tex2D(_RemapTex, u_xlat0.xy);
					    u_xlat0 = u_xlat0 * _TintColor;
					    o.SV_Target0.xyz = u_xlat0.xyz * float3(float3(_Boost, _Boost, _Boost));
					    o.SV_Target0.w = u_xlat0.w;
					    return o;
					}

#endif

#if 1 && defined (DIRECTIONAL) && defined (LIGHTPROBE_SH) && !defined (FADE_FROM_VERTEX_COLORS) && !defined (TRIPLANAR) && defined (SHADOWS_SCREEN) && !defined (INSTANCING_ON)

					uniform float4 _TintColor;
					uniform float _ExternalAlpha;
					uniform float4 _CutoffScroll;
					uniform float _InvFade;
					uniform float _IntersectionStrength;
					uniform float _RimPower;
					uniform float _RimStrength;
					uniform float _SoftPower;
					uniform float _Boost;
					uniform float _AlphaBoost;
					uniform float4 unused_0_11[3];
					uniform  sampler2D _MainTex;
					uniform  sampler2D _Cloud1Tex;
					uniform  sampler2D _Cloud2Tex;
					uniform  sampler2D _CameraDepthTexture;
					uniform  sampler2D _RemapTex;
					struct target {
						float4 SV_Target0 : SV_Target0;
					};
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					target frag(inter i, bool isFrontFacing : SV_IsFrontFace)
					{
					    target o;
					float4 u_xlat0;
					float4 u_xlat1;
					float4 u_xlat2;
					float4 u_xlat3;
					float3 u_xlat4;
					float2 u_xlat5;
					bool u_xlatb5;
					    u_xlat0.x = ((isFrontFacing ? 0xffffffffu : uint(0)) != uint(0)) ? 1.0 : -1.0;
					    u_xlat4.xyz = (-i.vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat1.x = dot(u_xlat4.xyz, u_xlat4.xyz);
					    u_xlat1.x = rsqrt(u_xlat1.x);
					    u_xlat4.xyz = u_xlat4.xyz * u_xlat1.xxx;
					    u_xlat1 = tex2D(_MainTex, i.vs_TEXCOORD0.xy);
					    u_xlat1.x = u_xlat1.w * _TintColor.w;
					    u_xlat1.x = u_xlat1.x * i.vs_COLOR0.w;
					    u_xlat5.xy = _Time.xx * _CutoffScroll.xy + i.vs_TEXCOORD0.zw;
					    u_xlat2 = tex2D(_Cloud1Tex, u_xlat5.xy);
					    u_xlat5.xy = _Time.xx * _CutoffScroll.zw + i.vs_TEXCOORD1.xy;
					    u_xlat3 = tex2D(_Cloud2Tex, u_xlat5.xy);
					    u_xlat1.x = u_xlat1.x * u_xlat2.w;
					    u_xlat1.x = u_xlat3.w * u_xlat1.x;
					    u_xlat1.x = u_xlat1.x * 4.0;
					    u_xlat1.x = u_xlat1.x * _AlphaBoost;
					    u_xlat1.x = u_xlat1.x * _ExternalAlpha;
					    u_xlatb5 = 0.0<_InvFade;
					    if(u_xlatb5){
					        u_xlat5.xy = i.vs_TEXCOORD4.xy / i.vs_TEXCOORD4.ww;
					        u_xlat2 = tex2D(_CameraDepthTexture, u_xlat5.xy);
					        u_xlat5.x = _ZBufferParams.z * u_xlat2.x + _ZBufferParams.w;
					        u_xlat5.x = float(1.0) / u_xlat5.x;
					        u_xlat5.x = u_xlat5.x + (-i.vs_TEXCOORD4.w);
					        u_xlat5.x = u_xlat5.x * _InvFade;
					        u_xlat5.x = clamp(u_xlat5.x, 0.0, 1.0);
					        u_xlat5.x = log2(u_xlat5.x);
					        u_xlat5.x = u_xlat5.x * _SoftPower;
					        u_xlat5.x = exp2(u_xlat5.x);
					    } else {
					        u_xlat5.x = 1.0;
					    }
					    u_xlat4.x = dot(u_xlat4.xyz, i.vs_TEXCOORD2.xyz);
					    u_xlat0.x = u_xlat0.x * u_xlat4.x;
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					    u_xlat0.x = (-u_xlat0.x) + 1.0;
					    u_xlat0.x = log2(u_xlat0.x);
					    u_xlat0.x = u_xlat0.x * _RimPower;
					    u_xlat0.x = exp2(u_xlat0.x);
					    u_xlat0.x = u_xlat0.x * _RimStrength + (-u_xlat5.x);
					    u_xlat0.x = u_xlat0.x + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat1.x;
					    u_xlat0.x = u_xlat0.x * _IntersectionStrength;
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					    u_xlat0.y = 0.5;
					    u_xlat0 = tex2D(_RemapTex, u_xlat0.xy);
					    u_xlat0 = u_xlat0 * _TintColor;
					    o.SV_Target0.xyz = u_xlat0.xyz * float3(float3(_Boost, _Boost, _Boost));
					    o.SV_Target0.w = u_xlat0.w;
					    return o;
					}

#endif

#if 1 && defined (DIRECTIONAL) && !defined (LIGHTPROBE_SH) && defined (FADE_FROM_VERTEX_COLORS) && !defined (TRIPLANAR) && !defined (SHADOWS_SCREEN) && !defined (INSTANCING_ON)

					uniform float4 _TintColor;
					uniform float _ExternalAlpha;
					uniform float4 _CutoffScroll;
					uniform float _InvFade;
					uniform float _IntersectionStrength;
					uniform float _RimPower;
					uniform float _RimStrength;
					uniform float _SoftPower;
					uniform float _Boost;
					uniform float _AlphaBoost;
					uniform float4 unused_0_11[3];
					uniform  sampler2D _MainTex;
					uniform  sampler2D _Cloud1Tex;
					uniform  sampler2D _Cloud2Tex;
					uniform  sampler2D _CameraDepthTexture;
					uniform  sampler2D _RemapTex;
					struct target {
						float4 SV_Target0 : SV_Target0;
					};
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					target frag(inter i, bool isFrontFacing : SV_IsFrontFace)
					{
					    target o;
					float4 u_xlat0;
					float4 u_xlat1;
					float4 u_xlat2;
					float4 u_xlat3;
					float3 u_xlat4;
					float2 u_xlat5;
					bool u_xlatb5;
					    u_xlat0.x = ((isFrontFacing ? 0xffffffffu : uint(0)) != uint(0)) ? 1.0 : -1.0;
					    u_xlat4.xyz = (-i.vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat1.x = dot(u_xlat4.xyz, u_xlat4.xyz);
					    u_xlat1.x = rsqrt(u_xlat1.x);
					    u_xlat4.xyz = u_xlat4.xyz * u_xlat1.xxx;
					    u_xlat1 = tex2D(_MainTex, i.vs_TEXCOORD0.xy);
					    u_xlat1.x = u_xlat1.w * _TintColor.w;
					    u_xlat1.x = u_xlat1.x * i.vs_COLOR0.w;
					    u_xlat5.xy = _Time.xx * _CutoffScroll.xy + i.vs_TEXCOORD0.zw;
					    u_xlat2 = tex2D(_Cloud1Tex, u_xlat5.xy);
					    u_xlat5.xy = _Time.xx * _CutoffScroll.zw + i.vs_TEXCOORD1.xy;
					    u_xlat3 = tex2D(_Cloud2Tex, u_xlat5.xy);
					    u_xlat1.x = u_xlat1.x * u_xlat2.w;
					    u_xlat1.x = u_xlat3.w * u_xlat1.x;
					    u_xlat1.x = u_xlat1.x * 4.0;
					    u_xlat1.x = u_xlat1.x * _AlphaBoost;
					    u_xlat1.x = u_xlat1.x * _ExternalAlpha;
					    u_xlatb5 = 0.0<_InvFade;
					    if(u_xlatb5){
					        u_xlat5.xy = i.vs_TEXCOORD4.xy / i.vs_TEXCOORD4.ww;
					        u_xlat2 = tex2D(_CameraDepthTexture, u_xlat5.xy);
					        u_xlat5.x = _ZBufferParams.z * u_xlat2.x + _ZBufferParams.w;
					        u_xlat5.x = float(1.0) / u_xlat5.x;
					        u_xlat5.x = u_xlat5.x + (-i.vs_TEXCOORD4.w);
					        u_xlat5.x = u_xlat5.x * _InvFade;
					        u_xlat5.x = clamp(u_xlat5.x, 0.0, 1.0);
					        u_xlat5.x = log2(u_xlat5.x);
					        u_xlat5.x = u_xlat5.x * _SoftPower;
					        u_xlat5.x = exp2(u_xlat5.x);
					    } else {
					        u_xlat5.x = 1.0;
					    }
					    u_xlat4.x = dot(u_xlat4.xyz, i.vs_TEXCOORD2.xyz);
					    u_xlat0.x = u_xlat0.x * u_xlat4.x;
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					    u_xlat0.x = (-u_xlat0.x) + 1.0;
					    u_xlat0.x = log2(u_xlat0.x);
					    u_xlat0.x = u_xlat0.x * _RimPower;
					    u_xlat0.x = exp2(u_xlat0.x);
					    u_xlat0.x = u_xlat0.x * _RimStrength + (-u_xlat5.x);
					    u_xlat0.x = u_xlat0.x + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat1.x;
					    u_xlat0.x = u_xlat0.x * _IntersectionStrength;
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					    u_xlat0.y = 0.5;
					    u_xlat0 = tex2D(_RemapTex, u_xlat0.xy);
					    u_xlat0 = u_xlat0 * _TintColor;
					    o.SV_Target0.w = u_xlat0.w * i.vs_COLOR0.x;
					    o.SV_Target0.xyz = u_xlat0.xyz * float3(float3(_Boost, _Boost, _Boost));
					    return o;
					}

#endif

#if 1 && defined (DIRECTIONAL) && !defined (LIGHTPROBE_SH) && !defined (FADE_FROM_VERTEX_COLORS) && defined (TRIPLANAR) && !defined (SHADOWS_SCREEN) && !defined (INSTANCING_ON)

					uniform float4 _TintColor;
					uniform float _ExternalAlpha;
					uniform float4 _CutoffScroll;
					uniform float _InvFade;
					uniform float _IntersectionStrength;
					uniform float _RimPower;
					uniform float _RimStrength;
					uniform float _SoftPower;
					uniform float _Boost;
					uniform float _AlphaBoost;
					uniform float4 _Cloud1Tex_ST;
					uniform float4 _Cloud2Tex_ST;
					uniform float4 unused_0_13;
					uniform  sampler2D _MainTex;
					uniform  sampler2D _Cloud1Tex;
					uniform  sampler2D _Cloud2Tex;
					uniform  sampler2D _CameraDepthTexture;
					uniform  sampler2D _RemapTex;
					struct target {
						float4 SV_Target0 : SV_Target0;
					};
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					target frag(inter i, bool isFrontFacing : SV_IsFrontFace)
					{
					    target o;
					float4 u_xlat0;
					float4 u_xlat1;
					float4 u_xlat2;
					float4 u_xlat3;
					float4 u_xlat4;
					float4 u_xlat5;
					float4 u_xlat6;
					float4 u_xlat7;
					float3 u_xlat8;
					float3 u_xlat9;
					bool u_xlatb9;
					float u_xlat17;
					    u_xlat0.x = ((isFrontFacing ? 0xffffffffu : uint(0)) != uint(0)) ? 1.0 : -1.0;
					    u_xlat8.xyz = (-i.vs_TEXCOORD2.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat1.x = dot(u_xlat8.xyz, u_xlat8.xyz);
					    u_xlat1.x = rsqrt(u_xlat1.x);
					    u_xlat8.xyz = u_xlat8.xyz * u_xlat1.xxx;
					    u_xlat1 = tex2D(_MainTex, i.vs_TEXCOORD0.xy);
					    u_xlat1.x = u_xlat1.w * _TintColor.w;
					    u_xlat1.x = u_xlat1.x * i.vs_COLOR0.w;
					    u_xlat9.x = abs(i.vs_TEXCOORD1.y) + abs(i.vs_TEXCOORD1.x);
					    u_xlat9.x = u_xlat9.x + abs(i.vs_TEXCOORD1.z);
					    u_xlat9.xyz = abs(i.vs_TEXCOORD1.xyz) / u_xlat9.xxx;
					    u_xlat2 = _Time.xxxx * _CutoffScroll.xyxy + i.vs_TEXCOORD2.zyxz;
					    u_xlat2 = u_xlat2 * _Cloud1Tex_ST.xyxy;
					    u_xlat3 = tex2D(_Cloud1Tex, u_xlat2.xy);
					    u_xlat2 = tex2D(_Cloud1Tex, u_xlat2.zw);
					    u_xlat4 = _Time.xxxx * _CutoffScroll + i.vs_TEXCOORD2.xyzy;
					    u_xlat2.xy = u_xlat4.xy * _Cloud1Tex_ST.xy;
					    u_xlat5 = tex2D(_Cloud1Tex, u_xlat2.xy);
					    u_xlat2.xy = u_xlat4.zw * _Cloud2Tex_ST.xy;
					    u_xlat4 = tex2D(_Cloud2Tex, u_xlat2.xy);
					    u_xlat6 = _Time.xxxx * _CutoffScroll.zwzw + i.vs_TEXCOORD2.xzxy;
					    u_xlat6 = u_xlat6 * _Cloud2Tex_ST.xyxy;
					    u_xlat7 = tex2D(_Cloud2Tex, u_xlat6.xy);
					    u_xlat6 = tex2D(_Cloud2Tex, u_xlat6.zw);
					    u_xlat2.x = u_xlat9.y * u_xlat2.w;
					    u_xlat2.x = u_xlat9.x * u_xlat3.w + u_xlat2.x;
					    u_xlat2.x = u_xlat9.z * u_xlat5.w + u_xlat2.x;
					    u_xlat17 = u_xlat9.y * u_xlat7.w;
					    u_xlat9.x = u_xlat9.x * u_xlat4.w + u_xlat17;
					    u_xlat9.x = u_xlat9.z * u_xlat6.w + u_xlat9.x;
					    u_xlat1.x = u_xlat1.x * u_xlat2.x;
					    u_xlat1.x = u_xlat9.x * u_xlat1.x;
					    u_xlat1.x = u_xlat1.x * 4.0;
					    u_xlat1.x = u_xlat1.x * _AlphaBoost;
					    u_xlat1.x = u_xlat1.x * _ExternalAlpha;
					    u_xlatb9 = 0.0<_InvFade;
					    if(u_xlatb9){
					        u_xlat9.xy = i.vs_TEXCOORD3.xy / i.vs_TEXCOORD3.ww;
					        u_xlat2 = tex2D(_CameraDepthTexture, u_xlat9.xy);
					        u_xlat9.x = _ZBufferParams.z * u_xlat2.x + _ZBufferParams.w;
					        u_xlat9.x = float(1.0) / u_xlat9.x;
					        u_xlat9.x = u_xlat9.x + (-i.vs_TEXCOORD3.w);
					        u_xlat9.x = u_xlat9.x * _InvFade;
					        u_xlat9.x = clamp(u_xlat9.x, 0.0, 1.0);
					        u_xlat9.x = log2(u_xlat9.x);
					        u_xlat9.x = u_xlat9.x * _SoftPower;
					        u_xlat9.x = exp2(u_xlat9.x);
					    } else {
					        u_xlat9.x = 1.0;
					    }
					    u_xlat8.x = dot(u_xlat8.xyz, i.vs_TEXCOORD1.xyz);
					    u_xlat0.x = u_xlat0.x * u_xlat8.x;
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					    u_xlat0.x = (-u_xlat0.x) + 1.0;
					    u_xlat0.x = log2(u_xlat0.x);
					    u_xlat0.x = u_xlat0.x * _RimPower;
					    u_xlat0.x = exp2(u_xlat0.x);
					    u_xlat0.x = u_xlat0.x * _RimStrength + (-u_xlat9.x);
					    u_xlat0.x = u_xlat0.x + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat1.x;
					    u_xlat0.x = u_xlat0.x * _IntersectionStrength;
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					    u_xlat0.y = 0.5;
					    u_xlat0 = tex2D(_RemapTex, u_xlat0.xy);
					    u_xlat0 = u_xlat0 * _TintColor;
					    o.SV_Target0.xyz = u_xlat0.xyz * float3(float3(_Boost, _Boost, _Boost));
					    o.SV_Target0.w = u_xlat0.w;
					    return o;
					}

#endif

#if 1 && defined (DIRECTIONAL) && !defined (LIGHTPROBE_SH) && !defined (FADE_FROM_VERTEX_COLORS) && !defined (TRIPLANAR) && !defined (SHADOWS_SCREEN) && defined (INSTANCING_ON)

					uniform float4 _TintColor;
					uniform float _ExternalAlpha;
					uniform float4 _CutoffScroll;
					uniform float _InvFade;
					uniform float _IntersectionStrength;
					uniform float _RimPower;
					uniform float _RimStrength;
					uniform float _SoftPower;
					uniform float _Boost;
					uniform float _AlphaBoost;
					uniform float4 unused_0_11[3];
					uniform  sampler2D _MainTex;
					uniform  sampler2D _Cloud1Tex;
					uniform  sampler2D _Cloud2Tex;
					uniform  sampler2D _CameraDepthTexture;
					uniform  sampler2D _RemapTex;
					struct target {
						float4 SV_Target0 : SV_Target0;
					};
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					target frag(inter i, bool isFrontFacing : SV_IsFrontFace)
					{
					    target o;
					float4 u_xlat0;
					float4 u_xlat1;
					float4 u_xlat2;
					float4 u_xlat3;
					float3 u_xlat4;
					float2 u_xlat5;
					bool u_xlatb5;
					    u_xlat0.x = ((isFrontFacing ? 0xffffffffu : uint(0)) != uint(0)) ? 1.0 : -1.0;
					    u_xlat4.xyz = (-i.vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat1.x = dot(u_xlat4.xyz, u_xlat4.xyz);
					    u_xlat1.x = rsqrt(u_xlat1.x);
					    u_xlat4.xyz = u_xlat4.xyz * u_xlat1.xxx;
					    u_xlat1 = tex2D(_MainTex, i.vs_TEXCOORD0.xy);
					    u_xlat1.x = u_xlat1.w * _TintColor.w;
					    u_xlat1.x = u_xlat1.x * i.vs_COLOR0.w;
					    u_xlat5.xy = _Time.xx * _CutoffScroll.xy + i.vs_TEXCOORD0.zw;
					    u_xlat2 = tex2D(_Cloud1Tex, u_xlat5.xy);
					    u_xlat5.xy = _Time.xx * _CutoffScroll.zw + i.vs_TEXCOORD1.xy;
					    u_xlat3 = tex2D(_Cloud2Tex, u_xlat5.xy);
					    u_xlat1.x = u_xlat1.x * u_xlat2.w;
					    u_xlat1.x = u_xlat3.w * u_xlat1.x;
					    u_xlat1.x = u_xlat1.x * 4.0;
					    u_xlat1.x = u_xlat1.x * _AlphaBoost;
					    u_xlat1.x = u_xlat1.x * _ExternalAlpha;
					    u_xlatb5 = 0.0<_InvFade;
					    if(u_xlatb5){
					        u_xlat5.xy = i.vs_TEXCOORD4.xy / i.vs_TEXCOORD4.ww;
					        u_xlat2 = tex2D(_CameraDepthTexture, u_xlat5.xy);
					        u_xlat5.x = _ZBufferParams.z * u_xlat2.x + _ZBufferParams.w;
					        u_xlat5.x = float(1.0) / u_xlat5.x;
					        u_xlat5.x = u_xlat5.x + (-i.vs_TEXCOORD4.w);
					        u_xlat5.x = u_xlat5.x * _InvFade;
					        u_xlat5.x = clamp(u_xlat5.x, 0.0, 1.0);
					        u_xlat5.x = log2(u_xlat5.x);
					        u_xlat5.x = u_xlat5.x * _SoftPower;
					        u_xlat5.x = exp2(u_xlat5.x);
					    } else {
					        u_xlat5.x = 1.0;
					    }
					    u_xlat4.x = dot(u_xlat4.xyz, i.vs_TEXCOORD2.xyz);
					    u_xlat0.x = u_xlat0.x * u_xlat4.x;
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					    u_xlat0.x = (-u_xlat0.x) + 1.0;
					    u_xlat0.x = log2(u_xlat0.x);
					    u_xlat0.x = u_xlat0.x * _RimPower;
					    u_xlat0.x = exp2(u_xlat0.x);
					    u_xlat0.x = u_xlat0.x * _RimStrength + (-u_xlat5.x);
					    u_xlat0.x = u_xlat0.x + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat1.x;
					    u_xlat0.x = u_xlat0.x * _IntersectionStrength;
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					    u_xlat0.y = 0.5;
					    u_xlat0 = tex2D(_RemapTex, u_xlat0.xy);
					    u_xlat0 = u_xlat0 * _TintColor;
					    o.SV_Target0.xyz = u_xlat0.xyz * float3(float3(_Boost, _Boost, _Boost));
					    o.SV_Target0.w = u_xlat0.w;
					    return o;
					}

#endif

#if 1 && defined (DIRECTIONAL) && defined (LIGHTPROBE_SH) && defined (FADE_FROM_VERTEX_COLORS) && !defined (TRIPLANAR) && !defined (SHADOWS_SCREEN) && defined (INSTANCING_ON)

					uniform float4 _TintColor;
					uniform float _ExternalAlpha;
					uniform float4 _CutoffScroll;
					uniform float _InvFade;
					uniform float _IntersectionStrength;
					uniform float _RimPower;
					uniform float _RimStrength;
					uniform float _SoftPower;
					uniform float _Boost;
					uniform float _AlphaBoost;
					uniform float4 unused_0_11[3];
					uniform  sampler2D _MainTex;
					uniform  sampler2D _Cloud1Tex;
					uniform  sampler2D _Cloud2Tex;
					uniform  sampler2D _CameraDepthTexture;
					uniform  sampler2D _RemapTex;
					struct target {
						float4 SV_Target0 : SV_Target0;
					};
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					target frag(inter i, bool isFrontFacing : SV_IsFrontFace)
					{
					    target o;
					float4 u_xlat0;
					float4 u_xlat1;
					float4 u_xlat2;
					float4 u_xlat3;
					float3 u_xlat4;
					float2 u_xlat5;
					bool u_xlatb5;
					    u_xlat0.x = ((isFrontFacing ? 0xffffffffu : uint(0)) != uint(0)) ? 1.0 : -1.0;
					    u_xlat4.xyz = (-i.vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat1.x = dot(u_xlat4.xyz, u_xlat4.xyz);
					    u_xlat1.x = rsqrt(u_xlat1.x);
					    u_xlat4.xyz = u_xlat4.xyz * u_xlat1.xxx;
					    u_xlat1 = tex2D(_MainTex, i.vs_TEXCOORD0.xy);
					    u_xlat1.x = u_xlat1.w * _TintColor.w;
					    u_xlat1.x = u_xlat1.x * i.vs_COLOR0.w;
					    u_xlat5.xy = _Time.xx * _CutoffScroll.xy + i.vs_TEXCOORD0.zw;
					    u_xlat2 = tex2D(_Cloud1Tex, u_xlat5.xy);
					    u_xlat5.xy = _Time.xx * _CutoffScroll.zw + i.vs_TEXCOORD1.xy;
					    u_xlat3 = tex2D(_Cloud2Tex, u_xlat5.xy);
					    u_xlat1.x = u_xlat1.x * u_xlat2.w;
					    u_xlat1.x = u_xlat3.w * u_xlat1.x;
					    u_xlat1.x = u_xlat1.x * 4.0;
					    u_xlat1.x = u_xlat1.x * _AlphaBoost;
					    u_xlat1.x = u_xlat1.x * _ExternalAlpha;
					    u_xlatb5 = 0.0<_InvFade;
					    if(u_xlatb5){
					        u_xlat5.xy = i.vs_TEXCOORD4.xy / i.vs_TEXCOORD4.ww;
					        u_xlat2 = tex2D(_CameraDepthTexture, u_xlat5.xy);
					        u_xlat5.x = _ZBufferParams.z * u_xlat2.x + _ZBufferParams.w;
					        u_xlat5.x = float(1.0) / u_xlat5.x;
					        u_xlat5.x = u_xlat5.x + (-i.vs_TEXCOORD4.w);
					        u_xlat5.x = u_xlat5.x * _InvFade;
					        u_xlat5.x = clamp(u_xlat5.x, 0.0, 1.0);
					        u_xlat5.x = log2(u_xlat5.x);
					        u_xlat5.x = u_xlat5.x * _SoftPower;
					        u_xlat5.x = exp2(u_xlat5.x);
					    } else {
					        u_xlat5.x = 1.0;
					    }
					    u_xlat4.x = dot(u_xlat4.xyz, i.vs_TEXCOORD2.xyz);
					    u_xlat0.x = u_xlat0.x * u_xlat4.x;
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					    u_xlat0.x = (-u_xlat0.x) + 1.0;
					    u_xlat0.x = log2(u_xlat0.x);
					    u_xlat0.x = u_xlat0.x * _RimPower;
					    u_xlat0.x = exp2(u_xlat0.x);
					    u_xlat0.x = u_xlat0.x * _RimStrength + (-u_xlat5.x);
					    u_xlat0.x = u_xlat0.x + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat1.x;
					    u_xlat0.x = u_xlat0.x * _IntersectionStrength;
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					    u_xlat0.y = 0.5;
					    u_xlat0 = tex2D(_RemapTex, u_xlat0.xy);
					    u_xlat0 = u_xlat0 * _TintColor;
					    o.SV_Target0.w = u_xlat0.w * i.vs_COLOR0.x;
					    o.SV_Target0.xyz = u_xlat0.xyz * float3(float3(_Boost, _Boost, _Boost));
					    return o;
					}

#endif

#if 1 && defined (DIRECTIONAL) && defined (LIGHTPROBE_SH) && !defined (FADE_FROM_VERTEX_COLORS) && defined (TRIPLANAR) && !defined (SHADOWS_SCREEN) && defined (INSTANCING_ON)

					uniform float4 _TintColor;
					uniform float _ExternalAlpha;
					uniform float4 _CutoffScroll;
					uniform float _InvFade;
					uniform float _IntersectionStrength;
					uniform float _RimPower;
					uniform float _RimStrength;
					uniform float _SoftPower;
					uniform float _Boost;
					uniform float _AlphaBoost;
					uniform float4 _Cloud1Tex_ST;
					uniform float4 _Cloud2Tex_ST;
					uniform float4 unused_0_13;
					uniform  sampler2D _MainTex;
					uniform  sampler2D _Cloud1Tex;
					uniform  sampler2D _Cloud2Tex;
					uniform  sampler2D _CameraDepthTexture;
					uniform  sampler2D _RemapTex;
					struct target {
						float4 SV_Target0 : SV_Target0;
					};
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					target frag(inter i, bool isFrontFacing : SV_IsFrontFace)
					{
					    target o;
					float4 u_xlat0;
					float4 u_xlat1;
					float4 u_xlat2;
					float4 u_xlat3;
					float4 u_xlat4;
					float4 u_xlat5;
					float4 u_xlat6;
					float4 u_xlat7;
					float3 u_xlat8;
					float3 u_xlat9;
					bool u_xlatb9;
					float u_xlat17;
					    u_xlat0.x = ((isFrontFacing ? 0xffffffffu : uint(0)) != uint(0)) ? 1.0 : -1.0;
					    u_xlat8.xyz = (-i.vs_TEXCOORD2.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat1.x = dot(u_xlat8.xyz, u_xlat8.xyz);
					    u_xlat1.x = rsqrt(u_xlat1.x);
					    u_xlat8.xyz = u_xlat8.xyz * u_xlat1.xxx;
					    u_xlat1 = tex2D(_MainTex, i.vs_TEXCOORD0.xy);
					    u_xlat1.x = u_xlat1.w * _TintColor.w;
					    u_xlat1.x = u_xlat1.x * i.vs_COLOR0.w;
					    u_xlat9.x = abs(i.vs_TEXCOORD1.y) + abs(i.vs_TEXCOORD1.x);
					    u_xlat9.x = u_xlat9.x + abs(i.vs_TEXCOORD1.z);
					    u_xlat9.xyz = abs(i.vs_TEXCOORD1.xyz) / u_xlat9.xxx;
					    u_xlat2 = _Time.xxxx * _CutoffScroll.xyxy + i.vs_TEXCOORD2.zyxz;
					    u_xlat2 = u_xlat2 * _Cloud1Tex_ST.xyxy;
					    u_xlat3 = tex2D(_Cloud1Tex, u_xlat2.xy);
					    u_xlat2 = tex2D(_Cloud1Tex, u_xlat2.zw);
					    u_xlat4 = _Time.xxxx * _CutoffScroll + i.vs_TEXCOORD2.xyzy;
					    u_xlat2.xy = u_xlat4.xy * _Cloud1Tex_ST.xy;
					    u_xlat5 = tex2D(_Cloud1Tex, u_xlat2.xy);
					    u_xlat2.xy = u_xlat4.zw * _Cloud2Tex_ST.xy;
					    u_xlat4 = tex2D(_Cloud2Tex, u_xlat2.xy);
					    u_xlat6 = _Time.xxxx * _CutoffScroll.zwzw + i.vs_TEXCOORD2.xzxy;
					    u_xlat6 = u_xlat6 * _Cloud2Tex_ST.xyxy;
					    u_xlat7 = tex2D(_Cloud2Tex, u_xlat6.xy);
					    u_xlat6 = tex2D(_Cloud2Tex, u_xlat6.zw);
					    u_xlat2.x = u_xlat9.y * u_xlat2.w;
					    u_xlat2.x = u_xlat9.x * u_xlat3.w + u_xlat2.x;
					    u_xlat2.x = u_xlat9.z * u_xlat5.w + u_xlat2.x;
					    u_xlat17 = u_xlat9.y * u_xlat7.w;
					    u_xlat9.x = u_xlat9.x * u_xlat4.w + u_xlat17;
					    u_xlat9.x = u_xlat9.z * u_xlat6.w + u_xlat9.x;
					    u_xlat1.x = u_xlat1.x * u_xlat2.x;
					    u_xlat1.x = u_xlat9.x * u_xlat1.x;
					    u_xlat1.x = u_xlat1.x * 4.0;
					    u_xlat1.x = u_xlat1.x * _AlphaBoost;
					    u_xlat1.x = u_xlat1.x * _ExternalAlpha;
					    u_xlatb9 = 0.0<_InvFade;
					    if(u_xlatb9){
					        u_xlat9.xy = i.vs_TEXCOORD3.xy / i.vs_TEXCOORD3.ww;
					        u_xlat2 = tex2D(_CameraDepthTexture, u_xlat9.xy);
					        u_xlat9.x = _ZBufferParams.z * u_xlat2.x + _ZBufferParams.w;
					        u_xlat9.x = float(1.0) / u_xlat9.x;
					        u_xlat9.x = u_xlat9.x + (-i.vs_TEXCOORD3.w);
					        u_xlat9.x = u_xlat9.x * _InvFade;
					        u_xlat9.x = clamp(u_xlat9.x, 0.0, 1.0);
					        u_xlat9.x = log2(u_xlat9.x);
					        u_xlat9.x = u_xlat9.x * _SoftPower;
					        u_xlat9.x = exp2(u_xlat9.x);
					    } else {
					        u_xlat9.x = 1.0;
					    }
					    u_xlat8.x = dot(u_xlat8.xyz, i.vs_TEXCOORD1.xyz);
					    u_xlat0.x = u_xlat0.x * u_xlat8.x;
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					    u_xlat0.x = (-u_xlat0.x) + 1.0;
					    u_xlat0.x = log2(u_xlat0.x);
					    u_xlat0.x = u_xlat0.x * _RimPower;
					    u_xlat0.x = exp2(u_xlat0.x);
					    u_xlat0.x = u_xlat0.x * _RimStrength + (-u_xlat9.x);
					    u_xlat0.x = u_xlat0.x + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat1.x;
					    u_xlat0.x = u_xlat0.x * _IntersectionStrength;
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					    u_xlat0.y = 0.5;
					    u_xlat0 = tex2D(_RemapTex, u_xlat0.xy);
					    u_xlat0 = u_xlat0 * _TintColor;
					    o.SV_Target0.xyz = u_xlat0.xyz * float3(float3(_Boost, _Boost, _Boost));
					    o.SV_Target0.w = u_xlat0.w;
					    return o;
					}

#endif

#if 1 && defined (DIRECTIONAL) && defined (LIGHTPROBE_SH) && !defined (FADE_FROM_VERTEX_COLORS) && !defined (TRIPLANAR) && !defined (SHADOWS_SCREEN) && defined (INSTANCING_ON)

					uniform float4 _TintColor;
					uniform float _ExternalAlpha;
					uniform float4 _CutoffScroll;
					uniform float _InvFade;
					uniform float _IntersectionStrength;
					uniform float _RimPower;
					uniform float _RimStrength;
					uniform float _SoftPower;
					uniform float _Boost;
					uniform float _AlphaBoost;
					uniform float4 unused_0_11[3];
					uniform  sampler2D _MainTex;
					uniform  sampler2D _Cloud1Tex;
					uniform  sampler2D _Cloud2Tex;
					uniform  sampler2D _CameraDepthTexture;
					uniform  sampler2D _RemapTex;
					struct target {
						float4 SV_Target0 : SV_Target0;
					};
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					target frag(inter i, bool isFrontFacing : SV_IsFrontFace)
					{
					    target o;
					float4 u_xlat0;
					float4 u_xlat1;
					float4 u_xlat2;
					float4 u_xlat3;
					float3 u_xlat4;
					float2 u_xlat5;
					bool u_xlatb5;
					    u_xlat0.x = ((isFrontFacing ? 0xffffffffu : uint(0)) != uint(0)) ? 1.0 : -1.0;
					    u_xlat4.xyz = (-i.vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat1.x = dot(u_xlat4.xyz, u_xlat4.xyz);
					    u_xlat1.x = rsqrt(u_xlat1.x);
					    u_xlat4.xyz = u_xlat4.xyz * u_xlat1.xxx;
					    u_xlat1 = tex2D(_MainTex, i.vs_TEXCOORD0.xy);
					    u_xlat1.x = u_xlat1.w * _TintColor.w;
					    u_xlat1.x = u_xlat1.x * i.vs_COLOR0.w;
					    u_xlat5.xy = _Time.xx * _CutoffScroll.xy + i.vs_TEXCOORD0.zw;
					    u_xlat2 = tex2D(_Cloud1Tex, u_xlat5.xy);
					    u_xlat5.xy = _Time.xx * _CutoffScroll.zw + i.vs_TEXCOORD1.xy;
					    u_xlat3 = tex2D(_Cloud2Tex, u_xlat5.xy);
					    u_xlat1.x = u_xlat1.x * u_xlat2.w;
					    u_xlat1.x = u_xlat3.w * u_xlat1.x;
					    u_xlat1.x = u_xlat1.x * 4.0;
					    u_xlat1.x = u_xlat1.x * _AlphaBoost;
					    u_xlat1.x = u_xlat1.x * _ExternalAlpha;
					    u_xlatb5 = 0.0<_InvFade;
					    if(u_xlatb5){
					        u_xlat5.xy = i.vs_TEXCOORD4.xy / i.vs_TEXCOORD4.ww;
					        u_xlat2 = tex2D(_CameraDepthTexture, u_xlat5.xy);
					        u_xlat5.x = _ZBufferParams.z * u_xlat2.x + _ZBufferParams.w;
					        u_xlat5.x = float(1.0) / u_xlat5.x;
					        u_xlat5.x = u_xlat5.x + (-i.vs_TEXCOORD4.w);
					        u_xlat5.x = u_xlat5.x * _InvFade;
					        u_xlat5.x = clamp(u_xlat5.x, 0.0, 1.0);
					        u_xlat5.x = log2(u_xlat5.x);
					        u_xlat5.x = u_xlat5.x * _SoftPower;
					        u_xlat5.x = exp2(u_xlat5.x);
					    } else {
					        u_xlat5.x = 1.0;
					    }
					    u_xlat4.x = dot(u_xlat4.xyz, i.vs_TEXCOORD2.xyz);
					    u_xlat0.x = u_xlat0.x * u_xlat4.x;
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					    u_xlat0.x = (-u_xlat0.x) + 1.0;
					    u_xlat0.x = log2(u_xlat0.x);
					    u_xlat0.x = u_xlat0.x * _RimPower;
					    u_xlat0.x = exp2(u_xlat0.x);
					    u_xlat0.x = u_xlat0.x * _RimStrength + (-u_xlat5.x);
					    u_xlat0.x = u_xlat0.x + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat1.x;
					    u_xlat0.x = u_xlat0.x * _IntersectionStrength;
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					    u_xlat0.y = 0.5;
					    u_xlat0 = tex2D(_RemapTex, u_xlat0.xy);
					    u_xlat0 = u_xlat0 * _TintColor;
					    o.SV_Target0.xyz = u_xlat0.xyz * float3(float3(_Boost, _Boost, _Boost));
					    o.SV_Target0.w = u_xlat0.w;
					    return o;
					}

#endif

#if 1 && defined (DIRECTIONAL) && !defined (LIGHTPROBE_SH) && defined (FADE_FROM_VERTEX_COLORS) && !defined (TRIPLANAR) && defined (SHADOWS_SCREEN) && defined (INSTANCING_ON)

					uniform float4 _TintColor;
					uniform float _ExternalAlpha;
					uniform float4 _CutoffScroll;
					uniform float _InvFade;
					uniform float _IntersectionStrength;
					uniform float _RimPower;
					uniform float _RimStrength;
					uniform float _SoftPower;
					uniform float _Boost;
					uniform float _AlphaBoost;
					uniform float4 unused_0_11[3];
					uniform  sampler2D _MainTex;
					uniform  sampler2D _Cloud1Tex;
					uniform  sampler2D _Cloud2Tex;
					uniform  sampler2D _CameraDepthTexture;
					uniform  sampler2D _RemapTex;
					struct target {
						float4 SV_Target0 : SV_Target0;
					};
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					target frag(inter i, bool isFrontFacing : SV_IsFrontFace)
					{
					    target o;
					float4 u_xlat0;
					float4 u_xlat1;
					float4 u_xlat2;
					float4 u_xlat3;
					float3 u_xlat4;
					float2 u_xlat5;
					bool u_xlatb5;
					    u_xlat0.x = ((isFrontFacing ? 0xffffffffu : uint(0)) != uint(0)) ? 1.0 : -1.0;
					    u_xlat4.xyz = (-i.vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat1.x = dot(u_xlat4.xyz, u_xlat4.xyz);
					    u_xlat1.x = rsqrt(u_xlat1.x);
					    u_xlat4.xyz = u_xlat4.xyz * u_xlat1.xxx;
					    u_xlat1 = tex2D(_MainTex, i.vs_TEXCOORD0.xy);
					    u_xlat1.x = u_xlat1.w * _TintColor.w;
					    u_xlat1.x = u_xlat1.x * i.vs_COLOR0.w;
					    u_xlat5.xy = _Time.xx * _CutoffScroll.xy + i.vs_TEXCOORD0.zw;
					    u_xlat2 = tex2D(_Cloud1Tex, u_xlat5.xy);
					    u_xlat5.xy = _Time.xx * _CutoffScroll.zw + i.vs_TEXCOORD1.xy;
					    u_xlat3 = tex2D(_Cloud2Tex, u_xlat5.xy);
					    u_xlat1.x = u_xlat1.x * u_xlat2.w;
					    u_xlat1.x = u_xlat3.w * u_xlat1.x;
					    u_xlat1.x = u_xlat1.x * 4.0;
					    u_xlat1.x = u_xlat1.x * _AlphaBoost;
					    u_xlat1.x = u_xlat1.x * _ExternalAlpha;
					    u_xlatb5 = 0.0<_InvFade;
					    if(u_xlatb5){
					        u_xlat5.xy = i.vs_TEXCOORD4.xy / i.vs_TEXCOORD4.ww;
					        u_xlat2 = tex2D(_CameraDepthTexture, u_xlat5.xy);
					        u_xlat5.x = _ZBufferParams.z * u_xlat2.x + _ZBufferParams.w;
					        u_xlat5.x = float(1.0) / u_xlat5.x;
					        u_xlat5.x = u_xlat5.x + (-i.vs_TEXCOORD4.w);
					        u_xlat5.x = u_xlat5.x * _InvFade;
					        u_xlat5.x = clamp(u_xlat5.x, 0.0, 1.0);
					        u_xlat5.x = log2(u_xlat5.x);
					        u_xlat5.x = u_xlat5.x * _SoftPower;
					        u_xlat5.x = exp2(u_xlat5.x);
					    } else {
					        u_xlat5.x = 1.0;
					    }
					    u_xlat4.x = dot(u_xlat4.xyz, i.vs_TEXCOORD2.xyz);
					    u_xlat0.x = u_xlat0.x * u_xlat4.x;
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					    u_xlat0.x = (-u_xlat0.x) + 1.0;
					    u_xlat0.x = log2(u_xlat0.x);
					    u_xlat0.x = u_xlat0.x * _RimPower;
					    u_xlat0.x = exp2(u_xlat0.x);
					    u_xlat0.x = u_xlat0.x * _RimStrength + (-u_xlat5.x);
					    u_xlat0.x = u_xlat0.x + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat1.x;
					    u_xlat0.x = u_xlat0.x * _IntersectionStrength;
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					    u_xlat0.y = 0.5;
					    u_xlat0 = tex2D(_RemapTex, u_xlat0.xy);
					    u_xlat0 = u_xlat0 * _TintColor;
					    o.SV_Target0.w = u_xlat0.w * i.vs_COLOR0.x;
					    o.SV_Target0.xyz = u_xlat0.xyz * float3(float3(_Boost, _Boost, _Boost));
					    return o;
					}

#endif

#if 1 && defined (DIRECTIONAL) && !defined (LIGHTPROBE_SH) && !defined (FADE_FROM_VERTEX_COLORS) && defined (TRIPLANAR) && defined (SHADOWS_SCREEN) && defined (INSTANCING_ON)

					uniform float4 _TintColor;
					uniform float _ExternalAlpha;
					uniform float4 _CutoffScroll;
					uniform float _InvFade;
					uniform float _IntersectionStrength;
					uniform float _RimPower;
					uniform float _RimStrength;
					uniform float _SoftPower;
					uniform float _Boost;
					uniform float _AlphaBoost;
					uniform float4 _Cloud1Tex_ST;
					uniform float4 _Cloud2Tex_ST;
					uniform float4 unused_0_13;
					uniform  sampler2D _MainTex;
					uniform  sampler2D _Cloud1Tex;
					uniform  sampler2D _Cloud2Tex;
					uniform  sampler2D _CameraDepthTexture;
					uniform  sampler2D _RemapTex;
					struct target {
						float4 SV_Target0 : SV_Target0;
					};
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					target frag(inter i, bool isFrontFacing : SV_IsFrontFace)
					{
					    target o;
					float4 u_xlat0;
					float4 u_xlat1;
					float4 u_xlat2;
					float4 u_xlat3;
					float4 u_xlat4;
					float4 u_xlat5;
					float4 u_xlat6;
					float4 u_xlat7;
					float3 u_xlat8;
					float3 u_xlat9;
					bool u_xlatb9;
					float u_xlat17;
					    u_xlat0.x = ((isFrontFacing ? 0xffffffffu : uint(0)) != uint(0)) ? 1.0 : -1.0;
					    u_xlat8.xyz = (-i.vs_TEXCOORD2.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat1.x = dot(u_xlat8.xyz, u_xlat8.xyz);
					    u_xlat1.x = rsqrt(u_xlat1.x);
					    u_xlat8.xyz = u_xlat8.xyz * u_xlat1.xxx;
					    u_xlat1 = tex2D(_MainTex, i.vs_TEXCOORD0.xy);
					    u_xlat1.x = u_xlat1.w * _TintColor.w;
					    u_xlat1.x = u_xlat1.x * i.vs_COLOR0.w;
					    u_xlat9.x = abs(i.vs_TEXCOORD1.y) + abs(i.vs_TEXCOORD1.x);
					    u_xlat9.x = u_xlat9.x + abs(i.vs_TEXCOORD1.z);
					    u_xlat9.xyz = abs(i.vs_TEXCOORD1.xyz) / u_xlat9.xxx;
					    u_xlat2 = _Time.xxxx * _CutoffScroll.xyxy + i.vs_TEXCOORD2.zyxz;
					    u_xlat2 = u_xlat2 * _Cloud1Tex_ST.xyxy;
					    u_xlat3 = tex2D(_Cloud1Tex, u_xlat2.xy);
					    u_xlat2 = tex2D(_Cloud1Tex, u_xlat2.zw);
					    u_xlat4 = _Time.xxxx * _CutoffScroll + i.vs_TEXCOORD2.xyzy;
					    u_xlat2.xy = u_xlat4.xy * _Cloud1Tex_ST.xy;
					    u_xlat5 = tex2D(_Cloud1Tex, u_xlat2.xy);
					    u_xlat2.xy = u_xlat4.zw * _Cloud2Tex_ST.xy;
					    u_xlat4 = tex2D(_Cloud2Tex, u_xlat2.xy);
					    u_xlat6 = _Time.xxxx * _CutoffScroll.zwzw + i.vs_TEXCOORD2.xzxy;
					    u_xlat6 = u_xlat6 * _Cloud2Tex_ST.xyxy;
					    u_xlat7 = tex2D(_Cloud2Tex, u_xlat6.xy);
					    u_xlat6 = tex2D(_Cloud2Tex, u_xlat6.zw);
					    u_xlat2.x = u_xlat9.y * u_xlat2.w;
					    u_xlat2.x = u_xlat9.x * u_xlat3.w + u_xlat2.x;
					    u_xlat2.x = u_xlat9.z * u_xlat5.w + u_xlat2.x;
					    u_xlat17 = u_xlat9.y * u_xlat7.w;
					    u_xlat9.x = u_xlat9.x * u_xlat4.w + u_xlat17;
					    u_xlat9.x = u_xlat9.z * u_xlat6.w + u_xlat9.x;
					    u_xlat1.x = u_xlat1.x * u_xlat2.x;
					    u_xlat1.x = u_xlat9.x * u_xlat1.x;
					    u_xlat1.x = u_xlat1.x * 4.0;
					    u_xlat1.x = u_xlat1.x * _AlphaBoost;
					    u_xlat1.x = u_xlat1.x * _ExternalAlpha;
					    u_xlatb9 = 0.0<_InvFade;
					    if(u_xlatb9){
					        u_xlat9.xy = i.vs_TEXCOORD3.xy / i.vs_TEXCOORD3.ww;
					        u_xlat2 = tex2D(_CameraDepthTexture, u_xlat9.xy);
					        u_xlat9.x = _ZBufferParams.z * u_xlat2.x + _ZBufferParams.w;
					        u_xlat9.x = float(1.0) / u_xlat9.x;
					        u_xlat9.x = u_xlat9.x + (-i.vs_TEXCOORD3.w);
					        u_xlat9.x = u_xlat9.x * _InvFade;
					        u_xlat9.x = clamp(u_xlat9.x, 0.0, 1.0);
					        u_xlat9.x = log2(u_xlat9.x);
					        u_xlat9.x = u_xlat9.x * _SoftPower;
					        u_xlat9.x = exp2(u_xlat9.x);
					    } else {
					        u_xlat9.x = 1.0;
					    }
					    u_xlat8.x = dot(u_xlat8.xyz, i.vs_TEXCOORD1.xyz);
					    u_xlat0.x = u_xlat0.x * u_xlat8.x;
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					    u_xlat0.x = (-u_xlat0.x) + 1.0;
					    u_xlat0.x = log2(u_xlat0.x);
					    u_xlat0.x = u_xlat0.x * _RimPower;
					    u_xlat0.x = exp2(u_xlat0.x);
					    u_xlat0.x = u_xlat0.x * _RimStrength + (-u_xlat9.x);
					    u_xlat0.x = u_xlat0.x + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat1.x;
					    u_xlat0.x = u_xlat0.x * _IntersectionStrength;
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					    u_xlat0.y = 0.5;
					    u_xlat0 = tex2D(_RemapTex, u_xlat0.xy);
					    u_xlat0 = u_xlat0 * _TintColor;
					    o.SV_Target0.xyz = u_xlat0.xyz * float3(float3(_Boost, _Boost, _Boost));
					    o.SV_Target0.w = u_xlat0.w;
					    return o;
					}

#endif

#if 1 && defined (DIRECTIONAL) && !defined (LIGHTPROBE_SH) && !defined (FADE_FROM_VERTEX_COLORS) && !defined (TRIPLANAR) && defined (SHADOWS_SCREEN) && defined (INSTANCING_ON)

					uniform float4 _TintColor;
					uniform float _ExternalAlpha;
					uniform float4 _CutoffScroll;
					uniform float _InvFade;
					uniform float _IntersectionStrength;
					uniform float _RimPower;
					uniform float _RimStrength;
					uniform float _SoftPower;
					uniform float _Boost;
					uniform float _AlphaBoost;
					uniform float4 unused_0_11[3];
					uniform  sampler2D _MainTex;
					uniform  sampler2D _Cloud1Tex;
					uniform  sampler2D _Cloud2Tex;
					uniform  sampler2D _CameraDepthTexture;
					uniform  sampler2D _RemapTex;
					struct target {
						float4 SV_Target0 : SV_Target0;
					};
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					target frag(inter i, bool isFrontFacing : SV_IsFrontFace)
					{
					    target o;
					float4 u_xlat0;
					float4 u_xlat1;
					float4 u_xlat2;
					float4 u_xlat3;
					float3 u_xlat4;
					float2 u_xlat5;
					bool u_xlatb5;
					    u_xlat0.x = ((isFrontFacing ? 0xffffffffu : uint(0)) != uint(0)) ? 1.0 : -1.0;
					    u_xlat4.xyz = (-i.vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat1.x = dot(u_xlat4.xyz, u_xlat4.xyz);
					    u_xlat1.x = rsqrt(u_xlat1.x);
					    u_xlat4.xyz = u_xlat4.xyz * u_xlat1.xxx;
					    u_xlat1 = tex2D(_MainTex, i.vs_TEXCOORD0.xy);
					    u_xlat1.x = u_xlat1.w * _TintColor.w;
					    u_xlat1.x = u_xlat1.x * i.vs_COLOR0.w;
					    u_xlat5.xy = _Time.xx * _CutoffScroll.xy + i.vs_TEXCOORD0.zw;
					    u_xlat2 = tex2D(_Cloud1Tex, u_xlat5.xy);
					    u_xlat5.xy = _Time.xx * _CutoffScroll.zw + i.vs_TEXCOORD1.xy;
					    u_xlat3 = tex2D(_Cloud2Tex, u_xlat5.xy);
					    u_xlat1.x = u_xlat1.x * u_xlat2.w;
					    u_xlat1.x = u_xlat3.w * u_xlat1.x;
					    u_xlat1.x = u_xlat1.x * 4.0;
					    u_xlat1.x = u_xlat1.x * _AlphaBoost;
					    u_xlat1.x = u_xlat1.x * _ExternalAlpha;
					    u_xlatb5 = 0.0<_InvFade;
					    if(u_xlatb5){
					        u_xlat5.xy = i.vs_TEXCOORD4.xy / i.vs_TEXCOORD4.ww;
					        u_xlat2 = tex2D(_CameraDepthTexture, u_xlat5.xy);
					        u_xlat5.x = _ZBufferParams.z * u_xlat2.x + _ZBufferParams.w;
					        u_xlat5.x = float(1.0) / u_xlat5.x;
					        u_xlat5.x = u_xlat5.x + (-i.vs_TEXCOORD4.w);
					        u_xlat5.x = u_xlat5.x * _InvFade;
					        u_xlat5.x = clamp(u_xlat5.x, 0.0, 1.0);
					        u_xlat5.x = log2(u_xlat5.x);
					        u_xlat5.x = u_xlat5.x * _SoftPower;
					        u_xlat5.x = exp2(u_xlat5.x);
					    } else {
					        u_xlat5.x = 1.0;
					    }
					    u_xlat4.x = dot(u_xlat4.xyz, i.vs_TEXCOORD2.xyz);
					    u_xlat0.x = u_xlat0.x * u_xlat4.x;
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					    u_xlat0.x = (-u_xlat0.x) + 1.0;
					    u_xlat0.x = log2(u_xlat0.x);
					    u_xlat0.x = u_xlat0.x * _RimPower;
					    u_xlat0.x = exp2(u_xlat0.x);
					    u_xlat0.x = u_xlat0.x * _RimStrength + (-u_xlat5.x);
					    u_xlat0.x = u_xlat0.x + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat1.x;
					    u_xlat0.x = u_xlat0.x * _IntersectionStrength;
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					    u_xlat0.y = 0.5;
					    u_xlat0 = tex2D(_RemapTex, u_xlat0.xy);
					    u_xlat0 = u_xlat0 * _TintColor;
					    o.SV_Target0.xyz = u_xlat0.xyz * float3(float3(_Boost, _Boost, _Boost));
					    o.SV_Target0.w = u_xlat0.w;
					    return o;
					}

#endif

#if 1 && defined (DIRECTIONAL) && defined (LIGHTPROBE_SH) && defined (FADE_FROM_VERTEX_COLORS) && !defined (TRIPLANAR) && defined (SHADOWS_SCREEN) && defined (INSTANCING_ON)

					uniform float4 _TintColor;
					uniform float _ExternalAlpha;
					uniform float4 _CutoffScroll;
					uniform float _InvFade;
					uniform float _IntersectionStrength;
					uniform float _RimPower;
					uniform float _RimStrength;
					uniform float _SoftPower;
					uniform float _Boost;
					uniform float _AlphaBoost;
					uniform float4 unused_0_11[3];
					uniform  sampler2D _MainTex;
					uniform  sampler2D _Cloud1Tex;
					uniform  sampler2D _Cloud2Tex;
					uniform  sampler2D _CameraDepthTexture;
					uniform  sampler2D _RemapTex;
					struct target {
						float4 SV_Target0 : SV_Target0;
					};
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					target frag(inter i, bool isFrontFacing : SV_IsFrontFace)
					{
					    target o;
					float4 u_xlat0;
					float4 u_xlat1;
					float4 u_xlat2;
					float4 u_xlat3;
					float3 u_xlat4;
					float2 u_xlat5;
					bool u_xlatb5;
					    u_xlat0.x = ((isFrontFacing ? 0xffffffffu : uint(0)) != uint(0)) ? 1.0 : -1.0;
					    u_xlat4.xyz = (-i.vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat1.x = dot(u_xlat4.xyz, u_xlat4.xyz);
					    u_xlat1.x = rsqrt(u_xlat1.x);
					    u_xlat4.xyz = u_xlat4.xyz * u_xlat1.xxx;
					    u_xlat1 = tex2D(_MainTex, i.vs_TEXCOORD0.xy);
					    u_xlat1.x = u_xlat1.w * _TintColor.w;
					    u_xlat1.x = u_xlat1.x * i.vs_COLOR0.w;
					    u_xlat5.xy = _Time.xx * _CutoffScroll.xy + i.vs_TEXCOORD0.zw;
					    u_xlat2 = tex2D(_Cloud1Tex, u_xlat5.xy);
					    u_xlat5.xy = _Time.xx * _CutoffScroll.zw + i.vs_TEXCOORD1.xy;
					    u_xlat3 = tex2D(_Cloud2Tex, u_xlat5.xy);
					    u_xlat1.x = u_xlat1.x * u_xlat2.w;
					    u_xlat1.x = u_xlat3.w * u_xlat1.x;
					    u_xlat1.x = u_xlat1.x * 4.0;
					    u_xlat1.x = u_xlat1.x * _AlphaBoost;
					    u_xlat1.x = u_xlat1.x * _ExternalAlpha;
					    u_xlatb5 = 0.0<_InvFade;
					    if(u_xlatb5){
					        u_xlat5.xy = i.vs_TEXCOORD4.xy / i.vs_TEXCOORD4.ww;
					        u_xlat2 = tex2D(_CameraDepthTexture, u_xlat5.xy);
					        u_xlat5.x = _ZBufferParams.z * u_xlat2.x + _ZBufferParams.w;
					        u_xlat5.x = float(1.0) / u_xlat5.x;
					        u_xlat5.x = u_xlat5.x + (-i.vs_TEXCOORD4.w);
					        u_xlat5.x = u_xlat5.x * _InvFade;
					        u_xlat5.x = clamp(u_xlat5.x, 0.0, 1.0);
					        u_xlat5.x = log2(u_xlat5.x);
					        u_xlat5.x = u_xlat5.x * _SoftPower;
					        u_xlat5.x = exp2(u_xlat5.x);
					    } else {
					        u_xlat5.x = 1.0;
					    }
					    u_xlat4.x = dot(u_xlat4.xyz, i.vs_TEXCOORD2.xyz);
					    u_xlat0.x = u_xlat0.x * u_xlat4.x;
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					    u_xlat0.x = (-u_xlat0.x) + 1.0;
					    u_xlat0.x = log2(u_xlat0.x);
					    u_xlat0.x = u_xlat0.x * _RimPower;
					    u_xlat0.x = exp2(u_xlat0.x);
					    u_xlat0.x = u_xlat0.x * _RimStrength + (-u_xlat5.x);
					    u_xlat0.x = u_xlat0.x + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat1.x;
					    u_xlat0.x = u_xlat0.x * _IntersectionStrength;
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					    u_xlat0.y = 0.5;
					    u_xlat0 = tex2D(_RemapTex, u_xlat0.xy);
					    u_xlat0 = u_xlat0 * _TintColor;
					    o.SV_Target0.w = u_xlat0.w * i.vs_COLOR0.x;
					    o.SV_Target0.xyz = u_xlat0.xyz * float3(float3(_Boost, _Boost, _Boost));
					    return o;
					}

#endif

#if 1 && defined (DIRECTIONAL) && defined (LIGHTPROBE_SH) && !defined (FADE_FROM_VERTEX_COLORS) && defined (TRIPLANAR) && defined (SHADOWS_SCREEN) && defined (INSTANCING_ON)

					uniform float4 _TintColor;
					uniform float _ExternalAlpha;
					uniform float4 _CutoffScroll;
					uniform float _InvFade;
					uniform float _IntersectionStrength;
					uniform float _RimPower;
					uniform float _RimStrength;
					uniform float _SoftPower;
					uniform float _Boost;
					uniform float _AlphaBoost;
					uniform float4 _Cloud1Tex_ST;
					uniform float4 _Cloud2Tex_ST;
					uniform float4 unused_0_13;
					uniform  sampler2D _MainTex;
					uniform  sampler2D _Cloud1Tex;
					uniform  sampler2D _Cloud2Tex;
					uniform  sampler2D _CameraDepthTexture;
					uniform  sampler2D _RemapTex;
					struct target {
						float4 SV_Target0 : SV_Target0;
					};
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					target frag(inter i, bool isFrontFacing : SV_IsFrontFace)
					{
					    target o;
					float4 u_xlat0;
					float4 u_xlat1;
					float4 u_xlat2;
					float4 u_xlat3;
					float4 u_xlat4;
					float4 u_xlat5;
					float4 u_xlat6;
					float4 u_xlat7;
					float3 u_xlat8;
					float3 u_xlat9;
					bool u_xlatb9;
					float u_xlat17;
					    u_xlat0.x = ((isFrontFacing ? 0xffffffffu : uint(0)) != uint(0)) ? 1.0 : -1.0;
					    u_xlat8.xyz = (-i.vs_TEXCOORD2.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat1.x = dot(u_xlat8.xyz, u_xlat8.xyz);
					    u_xlat1.x = rsqrt(u_xlat1.x);
					    u_xlat8.xyz = u_xlat8.xyz * u_xlat1.xxx;
					    u_xlat1 = tex2D(_MainTex, i.vs_TEXCOORD0.xy);
					    u_xlat1.x = u_xlat1.w * _TintColor.w;
					    u_xlat1.x = u_xlat1.x * i.vs_COLOR0.w;
					    u_xlat9.x = abs(i.vs_TEXCOORD1.y) + abs(i.vs_TEXCOORD1.x);
					    u_xlat9.x = u_xlat9.x + abs(i.vs_TEXCOORD1.z);
					    u_xlat9.xyz = abs(i.vs_TEXCOORD1.xyz) / u_xlat9.xxx;
					    u_xlat2 = _Time.xxxx * _CutoffScroll.xyxy + i.vs_TEXCOORD2.zyxz;
					    u_xlat2 = u_xlat2 * _Cloud1Tex_ST.xyxy;
					    u_xlat3 = tex2D(_Cloud1Tex, u_xlat2.xy);
					    u_xlat2 = tex2D(_Cloud1Tex, u_xlat2.zw);
					    u_xlat4 = _Time.xxxx * _CutoffScroll + i.vs_TEXCOORD2.xyzy;
					    u_xlat2.xy = u_xlat4.xy * _Cloud1Tex_ST.xy;
					    u_xlat5 = tex2D(_Cloud1Tex, u_xlat2.xy);
					    u_xlat2.xy = u_xlat4.zw * _Cloud2Tex_ST.xy;
					    u_xlat4 = tex2D(_Cloud2Tex, u_xlat2.xy);
					    u_xlat6 = _Time.xxxx * _CutoffScroll.zwzw + i.vs_TEXCOORD2.xzxy;
					    u_xlat6 = u_xlat6 * _Cloud2Tex_ST.xyxy;
					    u_xlat7 = tex2D(_Cloud2Tex, u_xlat6.xy);
					    u_xlat6 = tex2D(_Cloud2Tex, u_xlat6.zw);
					    u_xlat2.x = u_xlat9.y * u_xlat2.w;
					    u_xlat2.x = u_xlat9.x * u_xlat3.w + u_xlat2.x;
					    u_xlat2.x = u_xlat9.z * u_xlat5.w + u_xlat2.x;
					    u_xlat17 = u_xlat9.y * u_xlat7.w;
					    u_xlat9.x = u_xlat9.x * u_xlat4.w + u_xlat17;
					    u_xlat9.x = u_xlat9.z * u_xlat6.w + u_xlat9.x;
					    u_xlat1.x = u_xlat1.x * u_xlat2.x;
					    u_xlat1.x = u_xlat9.x * u_xlat1.x;
					    u_xlat1.x = u_xlat1.x * 4.0;
					    u_xlat1.x = u_xlat1.x * _AlphaBoost;
					    u_xlat1.x = u_xlat1.x * _ExternalAlpha;
					    u_xlatb9 = 0.0<_InvFade;
					    if(u_xlatb9){
					        u_xlat9.xy = i.vs_TEXCOORD3.xy / i.vs_TEXCOORD3.ww;
					        u_xlat2 = tex2D(_CameraDepthTexture, u_xlat9.xy);
					        u_xlat9.x = _ZBufferParams.z * u_xlat2.x + _ZBufferParams.w;
					        u_xlat9.x = float(1.0) / u_xlat9.x;
					        u_xlat9.x = u_xlat9.x + (-i.vs_TEXCOORD3.w);
					        u_xlat9.x = u_xlat9.x * _InvFade;
					        u_xlat9.x = clamp(u_xlat9.x, 0.0, 1.0);
					        u_xlat9.x = log2(u_xlat9.x);
					        u_xlat9.x = u_xlat9.x * _SoftPower;
					        u_xlat9.x = exp2(u_xlat9.x);
					    } else {
					        u_xlat9.x = 1.0;
					    }
					    u_xlat8.x = dot(u_xlat8.xyz, i.vs_TEXCOORD1.xyz);
					    u_xlat0.x = u_xlat0.x * u_xlat8.x;
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					    u_xlat0.x = (-u_xlat0.x) + 1.0;
					    u_xlat0.x = log2(u_xlat0.x);
					    u_xlat0.x = u_xlat0.x * _RimPower;
					    u_xlat0.x = exp2(u_xlat0.x);
					    u_xlat0.x = u_xlat0.x * _RimStrength + (-u_xlat9.x);
					    u_xlat0.x = u_xlat0.x + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat1.x;
					    u_xlat0.x = u_xlat0.x * _IntersectionStrength;
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					    u_xlat0.y = 0.5;
					    u_xlat0 = tex2D(_RemapTex, u_xlat0.xy);
					    u_xlat0 = u_xlat0 * _TintColor;
					    o.SV_Target0.xyz = u_xlat0.xyz * float3(float3(_Boost, _Boost, _Boost));
					    o.SV_Target0.w = u_xlat0.w;
					    return o;
					}

#endif

#if 1 && defined (DIRECTIONAL) && defined (LIGHTPROBE_SH) && !defined (FADE_FROM_VERTEX_COLORS) && !defined (TRIPLANAR) && defined (SHADOWS_SCREEN) && defined (INSTANCING_ON)

					uniform float4 _TintColor;
					uniform float _ExternalAlpha;
					uniform float4 _CutoffScroll;
					uniform float _InvFade;
					uniform float _IntersectionStrength;
					uniform float _RimPower;
					uniform float _RimStrength;
					uniform float _SoftPower;
					uniform float _Boost;
					uniform float _AlphaBoost;
					uniform float4 unused_0_11[3];
					uniform  sampler2D _MainTex;
					uniform  sampler2D _Cloud1Tex;
					uniform  sampler2D _Cloud2Tex;
					uniform  sampler2D _CameraDepthTexture;
					uniform  sampler2D _RemapTex;
					struct target {
						float4 SV_Target0 : SV_Target0;
					};
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					target frag(inter i, bool isFrontFacing : SV_IsFrontFace)
					{
					    target o;
					float4 u_xlat0;
					float4 u_xlat1;
					float4 u_xlat2;
					float4 u_xlat3;
					float3 u_xlat4;
					float2 u_xlat5;
					bool u_xlatb5;
					    u_xlat0.x = ((isFrontFacing ? 0xffffffffu : uint(0)) != uint(0)) ? 1.0 : -1.0;
					    u_xlat4.xyz = (-i.vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat1.x = dot(u_xlat4.xyz, u_xlat4.xyz);
					    u_xlat1.x = rsqrt(u_xlat1.x);
					    u_xlat4.xyz = u_xlat4.xyz * u_xlat1.xxx;
					    u_xlat1 = tex2D(_MainTex, i.vs_TEXCOORD0.xy);
					    u_xlat1.x = u_xlat1.w * _TintColor.w;
					    u_xlat1.x = u_xlat1.x * i.vs_COLOR0.w;
					    u_xlat5.xy = _Time.xx * _CutoffScroll.xy + i.vs_TEXCOORD0.zw;
					    u_xlat2 = tex2D(_Cloud1Tex, u_xlat5.xy);
					    u_xlat5.xy = _Time.xx * _CutoffScroll.zw + i.vs_TEXCOORD1.xy;
					    u_xlat3 = tex2D(_Cloud2Tex, u_xlat5.xy);
					    u_xlat1.x = u_xlat1.x * u_xlat2.w;
					    u_xlat1.x = u_xlat3.w * u_xlat1.x;
					    u_xlat1.x = u_xlat1.x * 4.0;
					    u_xlat1.x = u_xlat1.x * _AlphaBoost;
					    u_xlat1.x = u_xlat1.x * _ExternalAlpha;
					    u_xlatb5 = 0.0<_InvFade;
					    if(u_xlatb5){
					        u_xlat5.xy = i.vs_TEXCOORD4.xy / i.vs_TEXCOORD4.ww;
					        u_xlat2 = tex2D(_CameraDepthTexture, u_xlat5.xy);
					        u_xlat5.x = _ZBufferParams.z * u_xlat2.x + _ZBufferParams.w;
					        u_xlat5.x = float(1.0) / u_xlat5.x;
					        u_xlat5.x = u_xlat5.x + (-i.vs_TEXCOORD4.w);
					        u_xlat5.x = u_xlat5.x * _InvFade;
					        u_xlat5.x = clamp(u_xlat5.x, 0.0, 1.0);
					        u_xlat5.x = log2(u_xlat5.x);
					        u_xlat5.x = u_xlat5.x * _SoftPower;
					        u_xlat5.x = exp2(u_xlat5.x);
					    } else {
					        u_xlat5.x = 1.0;
					    }
					    u_xlat4.x = dot(u_xlat4.xyz, i.vs_TEXCOORD2.xyz);
					    u_xlat0.x = u_xlat0.x * u_xlat4.x;
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					    u_xlat0.x = (-u_xlat0.x) + 1.0;
					    u_xlat0.x = log2(u_xlat0.x);
					    u_xlat0.x = u_xlat0.x * _RimPower;
					    u_xlat0.x = exp2(u_xlat0.x);
					    u_xlat0.x = u_xlat0.x * _RimStrength + (-u_xlat5.x);
					    u_xlat0.x = u_xlat0.x + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat1.x;
					    u_xlat0.x = u_xlat0.x * _IntersectionStrength;
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					    u_xlat0.y = 0.5;
					    u_xlat0 = tex2D(_RemapTex, u_xlat0.xy);
					    u_xlat0 = u_xlat0 * _TintColor;
					    o.SV_Target0.xyz = u_xlat0.xyz * float3(float3(_Boost, _Boost, _Boost));
					    o.SV_Target0.w = u_xlat0.w;
					    return o;
					}

#endif

#if 1 && defined (DIRECTIONAL) && !defined (LIGHTPROBE_SH) && defined (FADE_FROM_VERTEX_COLORS) && !defined (TRIPLANAR) && !defined (SHADOWS_SCREEN) && defined (INSTANCING_ON)

					uniform float4 _TintColor;
					uniform float _ExternalAlpha;
					uniform float4 _CutoffScroll;
					uniform float _InvFade;
					uniform float _IntersectionStrength;
					uniform float _RimPower;
					uniform float _RimStrength;
					uniform float _SoftPower;
					uniform float _Boost;
					uniform float _AlphaBoost;
					uniform float4 unused_0_11[3];
					uniform  sampler2D _MainTex;
					uniform  sampler2D _Cloud1Tex;
					uniform  sampler2D _Cloud2Tex;
					uniform  sampler2D _CameraDepthTexture;
					uniform  sampler2D _RemapTex;
					struct target {
						float4 SV_Target0 : SV_Target0;
					};
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					target frag(inter i, bool isFrontFacing : SV_IsFrontFace)
					{
					    target o;
					float4 u_xlat0;
					float4 u_xlat1;
					float4 u_xlat2;
					float4 u_xlat3;
					float3 u_xlat4;
					float2 u_xlat5;
					bool u_xlatb5;
					    u_xlat0.x = ((isFrontFacing ? 0xffffffffu : uint(0)) != uint(0)) ? 1.0 : -1.0;
					    u_xlat4.xyz = (-i.vs_TEXCOORD3.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat1.x = dot(u_xlat4.xyz, u_xlat4.xyz);
					    u_xlat1.x = rsqrt(u_xlat1.x);
					    u_xlat4.xyz = u_xlat4.xyz * u_xlat1.xxx;
					    u_xlat1 = tex2D(_MainTex, i.vs_TEXCOORD0.xy);
					    u_xlat1.x = u_xlat1.w * _TintColor.w;
					    u_xlat1.x = u_xlat1.x * i.vs_COLOR0.w;
					    u_xlat5.xy = _Time.xx * _CutoffScroll.xy + i.vs_TEXCOORD0.zw;
					    u_xlat2 = tex2D(_Cloud1Tex, u_xlat5.xy);
					    u_xlat5.xy = _Time.xx * _CutoffScroll.zw + i.vs_TEXCOORD1.xy;
					    u_xlat3 = tex2D(_Cloud2Tex, u_xlat5.xy);
					    u_xlat1.x = u_xlat1.x * u_xlat2.w;
					    u_xlat1.x = u_xlat3.w * u_xlat1.x;
					    u_xlat1.x = u_xlat1.x * 4.0;
					    u_xlat1.x = u_xlat1.x * _AlphaBoost;
					    u_xlat1.x = u_xlat1.x * _ExternalAlpha;
					    u_xlatb5 = 0.0<_InvFade;
					    if(u_xlatb5){
					        u_xlat5.xy = i.vs_TEXCOORD4.xy / i.vs_TEXCOORD4.ww;
					        u_xlat2 = tex2D(_CameraDepthTexture, u_xlat5.xy);
					        u_xlat5.x = _ZBufferParams.z * u_xlat2.x + _ZBufferParams.w;
					        u_xlat5.x = float(1.0) / u_xlat5.x;
					        u_xlat5.x = u_xlat5.x + (-i.vs_TEXCOORD4.w);
					        u_xlat5.x = u_xlat5.x * _InvFade;
					        u_xlat5.x = clamp(u_xlat5.x, 0.0, 1.0);
					        u_xlat5.x = log2(u_xlat5.x);
					        u_xlat5.x = u_xlat5.x * _SoftPower;
					        u_xlat5.x = exp2(u_xlat5.x);
					    } else {
					        u_xlat5.x = 1.0;
					    }
					    u_xlat4.x = dot(u_xlat4.xyz, i.vs_TEXCOORD2.xyz);
					    u_xlat0.x = u_xlat0.x * u_xlat4.x;
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					    u_xlat0.x = (-u_xlat0.x) + 1.0;
					    u_xlat0.x = log2(u_xlat0.x);
					    u_xlat0.x = u_xlat0.x * _RimPower;
					    u_xlat0.x = exp2(u_xlat0.x);
					    u_xlat0.x = u_xlat0.x * _RimStrength + (-u_xlat5.x);
					    u_xlat0.x = u_xlat0.x + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat1.x;
					    u_xlat0.x = u_xlat0.x * _IntersectionStrength;
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					    u_xlat0.y = 0.5;
					    u_xlat0 = tex2D(_RemapTex, u_xlat0.xy);
					    u_xlat0 = u_xlat0 * _TintColor;
					    o.SV_Target0.w = u_xlat0.w * i.vs_COLOR0.x;
					    o.SV_Target0.xyz = u_xlat0.xyz * float3(float3(_Boost, _Boost, _Boost));
					    return o;
					}

#endif

#if 1 && defined (DIRECTIONAL) && !defined (LIGHTPROBE_SH) && !defined (FADE_FROM_VERTEX_COLORS) && defined (TRIPLANAR) && !defined (SHADOWS_SCREEN) && defined (INSTANCING_ON)

					uniform float4 _TintColor;
					uniform float _ExternalAlpha;
					uniform float4 _CutoffScroll;
					uniform float _InvFade;
					uniform float _IntersectionStrength;
					uniform float _RimPower;
					uniform float _RimStrength;
					uniform float _SoftPower;
					uniform float _Boost;
					uniform float _AlphaBoost;
					uniform float4 _Cloud1Tex_ST;
					uniform float4 _Cloud2Tex_ST;
					uniform float4 unused_0_13;
					uniform  sampler2D _MainTex;
					uniform  sampler2D _Cloud1Tex;
					uniform  sampler2D _Cloud2Tex;
					uniform  sampler2D _CameraDepthTexture;
					uniform  sampler2D _RemapTex;
					struct target {
						float4 SV_Target0 : SV_Target0;
					};
					#define HLSLCC_ENABLE_UNIFORM_BUFFERS 1
					#if HLSLCC_ENABLE_UNIFORM_BUFFERS
					#define UNITY_UNIFORM
					#else
					#define UNITY_UNIFORM uniform
					#endif
					#define UNITY_SUPPORTS_UNIFORM_LOCATION 1
					#if UNITY_SUPPORTS_UNIFORM_LOCATION
					#define UNITY_LOCATION(x) layout(location = x)
					#define UNITY_BINDING(x) layout(binding = x, std140)
					#else
					#define UNITY_LOCATION(x)
					#define UNITY_BINDING(x) layout(std140)
					#endif
					target frag(inter i, bool isFrontFacing : SV_IsFrontFace)
					{
					    target o;
					float4 u_xlat0;
					float4 u_xlat1;
					float4 u_xlat2;
					float4 u_xlat3;
					float4 u_xlat4;
					float4 u_xlat5;
					float4 u_xlat6;
					float4 u_xlat7;
					float3 u_xlat8;
					float3 u_xlat9;
					bool u_xlatb9;
					float u_xlat17;
					    u_xlat0.x = ((isFrontFacing ? 0xffffffffu : uint(0)) != uint(0)) ? 1.0 : -1.0;
					    u_xlat8.xyz = (-i.vs_TEXCOORD2.xyz) + _WorldSpaceCameraPos.xyz;
					    u_xlat1.x = dot(u_xlat8.xyz, u_xlat8.xyz);
					    u_xlat1.x = rsqrt(u_xlat1.x);
					    u_xlat8.xyz = u_xlat8.xyz * u_xlat1.xxx;
					    u_xlat1 = tex2D(_MainTex, i.vs_TEXCOORD0.xy);
					    u_xlat1.x = u_xlat1.w * _TintColor.w;
					    u_xlat1.x = u_xlat1.x * i.vs_COLOR0.w;
					    u_xlat9.x = abs(i.vs_TEXCOORD1.y) + abs(i.vs_TEXCOORD1.x);
					    u_xlat9.x = u_xlat9.x + abs(i.vs_TEXCOORD1.z);
					    u_xlat9.xyz = abs(i.vs_TEXCOORD1.xyz) / u_xlat9.xxx;
					    u_xlat2 = _Time.xxxx * _CutoffScroll.xyxy + i.vs_TEXCOORD2.zyxz;
					    u_xlat2 = u_xlat2 * _Cloud1Tex_ST.xyxy;
					    u_xlat3 = tex2D(_Cloud1Tex, u_xlat2.xy);
					    u_xlat2 = tex2D(_Cloud1Tex, u_xlat2.zw);
					    u_xlat4 = _Time.xxxx * _CutoffScroll + i.vs_TEXCOORD2.xyzy;
					    u_xlat2.xy = u_xlat4.xy * _Cloud1Tex_ST.xy;
					    u_xlat5 = tex2D(_Cloud1Tex, u_xlat2.xy);
					    u_xlat2.xy = u_xlat4.zw * _Cloud2Tex_ST.xy;
					    u_xlat4 = tex2D(_Cloud2Tex, u_xlat2.xy);
					    u_xlat6 = _Time.xxxx * _CutoffScroll.zwzw + i.vs_TEXCOORD2.xzxy;
					    u_xlat6 = u_xlat6 * _Cloud2Tex_ST.xyxy;
					    u_xlat7 = tex2D(_Cloud2Tex, u_xlat6.xy);
					    u_xlat6 = tex2D(_Cloud2Tex, u_xlat6.zw);
					    u_xlat2.x = u_xlat9.y * u_xlat2.w;
					    u_xlat2.x = u_xlat9.x * u_xlat3.w + u_xlat2.x;
					    u_xlat2.x = u_xlat9.z * u_xlat5.w + u_xlat2.x;
					    u_xlat17 = u_xlat9.y * u_xlat7.w;
					    u_xlat9.x = u_xlat9.x * u_xlat4.w + u_xlat17;
					    u_xlat9.x = u_xlat9.z * u_xlat6.w + u_xlat9.x;
					    u_xlat1.x = u_xlat1.x * u_xlat2.x;
					    u_xlat1.x = u_xlat9.x * u_xlat1.x;
					    u_xlat1.x = u_xlat1.x * 4.0;
					    u_xlat1.x = u_xlat1.x * _AlphaBoost;
					    u_xlat1.x = u_xlat1.x * _ExternalAlpha;
					    u_xlatb9 = 0.0<_InvFade;
					    if(u_xlatb9){
					        u_xlat9.xy = i.vs_TEXCOORD3.xy / i.vs_TEXCOORD3.ww;
					        u_xlat2 = tex2D(_CameraDepthTexture, u_xlat9.xy);
					        u_xlat9.x = _ZBufferParams.z * u_xlat2.x + _ZBufferParams.w;
					        u_xlat9.x = float(1.0) / u_xlat9.x;
					        u_xlat9.x = u_xlat9.x + (-i.vs_TEXCOORD3.w);
					        u_xlat9.x = u_xlat9.x * _InvFade;
					        u_xlat9.x = clamp(u_xlat9.x, 0.0, 1.0);
					        u_xlat9.x = log2(u_xlat9.x);
					        u_xlat9.x = u_xlat9.x * _SoftPower;
					        u_xlat9.x = exp2(u_xlat9.x);
					    } else {
					        u_xlat9.x = 1.0;
					    }
					    u_xlat8.x = dot(u_xlat8.xyz, i.vs_TEXCOORD1.xyz);
					    u_xlat0.x = u_xlat0.x * u_xlat8.x;
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					    u_xlat0.x = (-u_xlat0.x) + 1.0;
					    u_xlat0.x = log2(u_xlat0.x);
					    u_xlat0.x = u_xlat0.x * _RimPower;
					    u_xlat0.x = exp2(u_xlat0.x);
					    u_xlat0.x = u_xlat0.x * _RimStrength + (-u_xlat9.x);
					    u_xlat0.x = u_xlat0.x + 1.0;
					    u_xlat0.x = u_xlat0.x * u_xlat1.x;
					    u_xlat0.x = u_xlat0.x * _IntersectionStrength;
					    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
					    u_xlat0.y = 0.5;
					    u_xlat0 = tex2D(_RemapTex, u_xlat0.xy);
					    u_xlat0 = u_xlat0 * _TintColor;
					    o.SV_Target0.xyz = u_xlat0.xyz * float3(float3(_Boost, _Boost, _Boost));
					    o.SV_Target0.w = u_xlat0.w;
					    return o;
					}

#endif
			ENDCG
		}
	}
}
