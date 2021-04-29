﻿    Shader "Curvature" {
     
        Properties {
     
            _MainTex ("Base (RGB)", 2D) = "white" {}
     
        }
     
        SubShader {
     
            Tags { "RenderType"="AlphaTest" }
     
            //LOD 200
           
            Pass {
     
                CGPROGRAM
     
                    #pragma vertex vert
     
                    #pragma fragment frag
     
                    #include "UnityCG.cginc"
             
                    struct v2f {
     
                        float4 pos : SV_POSITION;
     
                        float2 uv_MainTex : TEXCOORD0;
     
                    };
               
                    float4 _MainTex_ST;
             
                    v2f vert(appdata_base v) {
     
                        v2f o;
     
                        //o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
     
                        //Curvature vertex modification
     
                        float4 pos = mul(UNITY_MATRIX_MV, v.vertex);
     
                        float distanceSquared = pos.x * pos.x + pos.z * pos.z;
     
                        // World Radius = 500; World Radius Squared = 250000
     
                        pos.y -= 500 - sqrt(max(1.0 - distanceSquared / 250000, 0.0)) * 500;
     
                        o.pos = mul(UNITY_MATRIX_P, pos);
     
                        //
                       
                        o.uv_MainTex = TRANSFORM_TEX(v.texcoord, _MainTex);
     
                        return o;
     
                    }
           
                    sampler2D _MainTex;
               
                    float4 frag(v2f IN) : COLOR {
     
                        half4 c = tex2D (_MainTex, IN.uv_MainTex);
     
                        return c;
     
                    }
     
                ENDCG
     
            }
     
        }
     
    }
