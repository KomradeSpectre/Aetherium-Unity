Shader "Unlit/NewUnlitShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		
		_ScrollSpeeds("Scroll Speeds", vector) = (1, 2, 0, 0)  // velocidade em cada direção

		_Color("Main Color", Color) = (1,1,1,1) // cor para mixtura na cena. padrão branco

		_NormalMap("NormalMap", 2D) = "white" {}
		_MainLightPosition("MainLightPosition", Vector) = (0,0,0,0)

	}
	SubShader
	{
		//Tags { "RenderType"="Opaque" }
		Tags{ "Queue" = "Transparent" "RenderType" = "Transparent" }
		Blend SrcAlpha OneMinusSrcAlpha

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;		// busca normais
				float3 tangent : TANGENT;	// busca tangentes
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;

				float3 lightdir : TEXCOORD1;	// armazena coordenadas para direção da luz
				float3 viewdir : TEXCOORD2;		// armazena coordenadas para direção da vista
				float3 T : TEXCOORD3;			// coordenada Tangent
				float3 B : TEXCOORD4;			// coordenada Binormal
				float3 N : TEXCOORD5;			// coordenada Normal

			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			float4 _ScrollSpeeds;

			fixed4 _Color;		// cor para ser multiplicada

			sampler2D _NormalMap;
			float3 _MainLightPosition;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				o.uv += _ScrollSpeeds * _Time.x; // Desloca coordenadas UV no tempo

				float4 worldPosition = mul(unity_ObjectToWorld, v.vertex);
				float3 lightDir = worldPosition.xyz - _MainLightPosition.xyz;
				o.lightdir = normalize(lightDir);	// calcula direção da luz

				float3 viewDir = normalize(worldPosition.xyz - _WorldSpaceCameraPos.xyz);
				o.viewdir = viewDir;	// calcula direção da vista

				// calcula vetor Normal, Binormal, Tangent em coordenadas do mundo
				float3 worldNormal = mul((float3x3)unity_ObjectToWorld, v.normal);
				float3 worldTangent = mul((float3x3)unity_ObjectToWorld, v.tangent);
				float3 binormal = cross(v.normal, v.tangent.xyz); 
				float3 worldBinormal = mul((float3x3)unity_ObjectToWorld, binormal);
				o.N = normalize(worldNormal);
				o.T = normalize(worldTangent);
				o.B = normalize(worldBinormal);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				
				fixed4 col = tex2D(_MainTex, i.uv);		// amostra a textura

				float3 tangentNormal = tex2D(_NormalMap, i.uv).xyz; // recupera normal da imagem
				tangentNormal = normalize(tangentNormal * 2 - 1); // normaliza valor ( 0 ~ 1 )

				float3x3 TBN = float3x3(normalize(i.T), normalize(i.B), normalize(i.N)); // TBN
				TBN = transpose(TBN); // a inversa de uma matriz ortogonal é sua transposta

				float3 worldNormal = mul(TBN, tangentNormal); // recupera vetor normal
			
				float3 lightDir = normalize(i.lightdir);	// normaliza direção da luz
				float3 diffuse = saturate(dot(worldNormal, -lightDir)); // calcula como cor difusa

				return col*_Color*float4(diffuse, 1);
				//return col*_Color; // just return it
				//return col;

			}
			ENDCG
		}
	}
}
