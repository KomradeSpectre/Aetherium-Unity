Shader "Custom/VaryingColor"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _RampTex ("Ramp texture", 2D) = "white" {}
        _Speed ("Speed", Range(-1000, 1000)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
 
        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
 
            #include "UnityCG.cginc"
           
            sampler2D _MainTex;
            sampler2D _RampTex;
            float _Speed;
 
            fixed4 frag (v2f_img i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                return tex2D(_RampTex, fixed2(col.r + _Time.x * _Speed, 0.5));
            }
            ENDCG
        }
		
		Pass
		{
			Name "META"
			Tags {"LightMode"="Meta"}
			Cull Off
			CGPROGRAM
					   
			#include "UnityStandardMeta.cginc"
			#pragma vertex vert_meta
			#pragma fragment frag_meta_custom
		 
			fixed4 frag_meta_custom (v2f_meta i) : SV_Target
			{
				// Colors                
				fixed4 col = fixed4(1,0,0,1); // The emission color
		 
				// Calculate emission
				UnityMetaInput metaIN;
				  UNITY_INITIALIZE_OUTPUT(UnityMetaInput, metaIN);
				  metaIN.Albedo = col.rgb;
				  metaIN.Emission = col.rgb;
				  return UnityMetaFragment(metaIN);
		 
				return col;
			}
		 
			ENDCG
		}		
    }
}