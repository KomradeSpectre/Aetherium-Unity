// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Glass"
{
	Properties
	{
		_SpecColor("Specular Color",Color)=(1,1,1,1)
		_Refraction("Refraction", Range( 0.95 , 0.99)) = 0.9858823
		_ReflectionTexture("ReflectionTexture", CUBE) = "white" {}
		_ColorRefraction("ColorRefraction", Range( 0 , 0.035)) = 0
		_NormalMap("NormalMap", 2D) = "white" {}
		_NormalIntensity("NormalIntensity", Range( 0 , 1)) = 1
		_EmissionScale("EmissionScale", Float) = 0.8
		_Texture("Texture", 2D) = "white" {}
		_AlbedoColor("AlbedoColor", Color) = (0,0,0,0)
		_Blending("Blending", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform float4 _AlbedoColor;
		uniform sampler2D _Texture;
		uniform float4 _Texture_ST;
		uniform float _Blending;
		uniform samplerCUBE _ReflectionTexture;
		uniform sampler2D _NormalMap;
		uniform float4 _NormalMap_ST;
		uniform float _NormalIntensity;
		uniform float _Refraction;
		uniform float _ColorRefraction;
		uniform float _EmissionScale;

		void surf( Input i , inout SurfaceOutput o )
		{
			o.Normal = float3(0,0,1);
			float2 uv_Texture = i.uv_texcoord * _Texture_ST.xy + _Texture_ST.zw;
			float4 temp_output_63_0 = ( _AlbedoColor * tex2D( _Texture, uv_Texture ) );
			o.Albedo = temp_output_63_0.rgb;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float2 uv_NormalMap = i.uv_texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			float3 newWorldNormal9 = (WorldNormalVector( i , ( tex2D( _NormalMap, uv_NormalMap ) * _NormalIntensity ).rgb ));
			float4 break27 = texCUBE( _ReflectionTexture, refract( -ase_worldViewDir , newWorldNormal9 , _Refraction ) );
			float4 appendResult30 = (float4(break27.r , texCUBE( _ReflectionTexture, refract( -ase_worldViewDir , newWorldNormal9 , ( _Refraction + _ColorRefraction ) ) ).g , texCUBE( _ReflectionTexture, refract( -ase_worldViewDir , newWorldNormal9 , ( _Refraction - _ColorRefraction ) ) ).b , break27.a));
			float layeredBlendVar64 = _Blending;
			float4 layeredBlend64 = ( lerp( temp_output_63_0,( appendResult30 * _EmissionScale ) , layeredBlendVar64 ) );
			o.Emission = layeredBlend64.rgb;
			float temp_output_53_0 = 1.0;
			o.Specular = temp_output_53_0;
			o.Gloss = temp_output_53_0;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf BlinnPhong keepalpha fullforwardshadows noshadow 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16200
311;92;1709;1069;-250.3658;677.0398;1.140539;True;True
Node;AmplifyShaderEditor.TexturePropertyNode;41;-2180.457,589.9973;Float;True;Property;_NormalMap;NormalMap;4;0;Create;True;0;0;False;0;None;None;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;43;-1933.578,420.2137;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;42;-1854.351,682.4982;Float;True;Property;_TextureSample3;Texture Sample 3;5;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;47;-1768.632,938.3647;Float;False;Property;_NormalIntensity;NormalIntensity;5;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-965,201;Float;False;Property;_Refraction;Refraction;1;0;Create;True;0;0;False;0;0.9858823;0.9858823;0.95;0.99;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;4;-991,12;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-1460.632,747.3647;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-1088.68,422.3427;Float;False;Property;_ColorRefraction;ColorRefraction;3;0;Create;True;0;0;False;0;0;0;0;0.035;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;9;-1274,642;Float;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NegateNode;5;-727,57;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;34;-632.6797,638.3427;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;23;-646,288;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0.005;False;1;FLOAT;0
Node;AmplifyShaderEditor.RefractOpVec;22;-427,424;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RefractOpVec;21;-436,231;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RefractOpVec;6;-437,64;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexturePropertyNode;16;-638,-315;Float;True;Property;_ReflectionTexture;ReflectionTexture;2;0;Create;True;0;0;False;0;None;None;False;white;LockedToCube;Cube;0;1;SAMPLERCUBE;0
Node;AmplifyShaderEditor.SamplerNode;12;-204,31;Float;True;Property;_Reflection;Reflection;1;0;Create;True;0;0;False;0;625f232df89d5924eb7b9508304f822b;625f232df89d5924eb7b9508304f822b;True;0;False;white;LockedToCube;False;Instance;-1;Auto;Cube;6;0;SAMPLER2D;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;20;-194,454;Float;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;False;0;625f232df89d5924eb7b9508304f822b;625f232df89d5924eb7b9508304f822b;True;0;False;white;LockedToCube;False;Instance;-1;Auto;Cube;6;0;SAMPLER2D;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;19;-194,240;Float;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;625f232df89d5924eb7b9508304f822b;625f232df89d5924eb7b9508304f822b;True;0;False;white;LockedToCube;False;Instance;-1;Auto;Cube;6;0;SAMPLER2D;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;54;332.5299,-474.4293;Float;True;Property;_Texture;Texture;7;0;Create;True;0;0;False;0;None;None;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.BreakToComponentsNode;31;138,263;Float;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.BreakToComponentsNode;27;138,117;Float;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.TextureCoordinatesNode;56;553.5299,-603.4293;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;32;129,440;Float;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DynamicAppendNode;30;506,220;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;52;564.8664,31.41136;Float;False;Property;_EmissionScale;EmissionScale;6;0;Create;True;0;0;False;0;0.8;0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;55;672.5299,-417.4293;Float;True;Property;_TextureSample2;Texture Sample 2;9;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;62;1067.669,-540.8658;Float;False;Property;_AlbedoColor;AlbedoColor;8;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;1028.783,26.32765;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;1176.87,-241.8659;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;65;1080.678,-62.28943;Float;False;Property;_Blending;Blending;9;0;Create;True;0;0;False;0;0;0.9;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LayeredBlendNode;64;1397.748,-78.25702;Float;False;6;0;FLOAT;1;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;53;611.6921,-54.47256;Float;False;Constant;_Specular;Specular;8;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;48;1628.343,-112.3424;Float;False;True;2;Float;ASEMaterialInspector;0;0;BlinnPhong;Glass;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;0;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;43;2;41;0
WireConnection;42;0;41;0
WireConnection;42;1;43;0
WireConnection;46;0;42;0
WireConnection;46;1;47;0
WireConnection;9;0;46;0
WireConnection;5;0;4;0
WireConnection;34;0;7;0
WireConnection;34;1;33;0
WireConnection;23;0;7;0
WireConnection;23;1;33;0
WireConnection;22;0;5;0
WireConnection;22;1;9;0
WireConnection;22;2;34;0
WireConnection;21;0;5;0
WireConnection;21;1;9;0
WireConnection;21;2;23;0
WireConnection;6;0;5;0
WireConnection;6;1;9;0
WireConnection;6;2;7;0
WireConnection;12;0;16;0
WireConnection;12;1;6;0
WireConnection;20;0;16;0
WireConnection;20;1;22;0
WireConnection;19;0;16;0
WireConnection;19;1;21;0
WireConnection;31;0;19;0
WireConnection;27;0;12;0
WireConnection;56;2;54;0
WireConnection;32;0;20;0
WireConnection;30;0;27;0
WireConnection;30;1;31;1
WireConnection;30;2;32;2
WireConnection;30;3;27;3
WireConnection;55;0;54;0
WireConnection;55;1;56;0
WireConnection;51;0;30;0
WireConnection;51;1;52;0
WireConnection;63;0;62;0
WireConnection;63;1;55;0
WireConnection;64;0;65;0
WireConnection;64;1;63;0
WireConnection;64;2;51;0
WireConnection;48;0;63;0
WireConnection;48;2;64;0
WireConnection;48;3;53;0
WireConnection;48;4;53;0
ASEEND*/
//CHKSM=653353B2C503E289B680CD4C4258C4EE93255322