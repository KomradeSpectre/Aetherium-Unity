Shader "Custom/Rim effect" {
    Properties {
        _MainTex ("Base (RGB)", 2D) = "white" {}
		_TextureColor ("Texture Color", Color) = (1, 1, 1, 1)
        _RimValue ("Rim value", Range(0, 1)) = 0.5
		_EmissionLM ("Emission (Lightmapper)", Float) = 0
		[Toggle] _DynamicEmissionLM ("Dynamic Emission (Lightmapper)", Int) = 0
    }
    SubShader {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
 
        CGPROGRAM
        #pragma surface surf Lambert alpha
 
        sampler2D _MainTex;
		fixed4 _TextureColor;
        fixed _RimValue;
 
        struct Input {
            float2 uv_MainTex;
            float3 viewDir;
            float3 worldNormal;
        };
 
        void surf (Input IN, inout SurfaceOutput o) {
            half4 c = tex2D (_MainTex, IN.uv_MainTex) * _TextureColor;
            o.Albedo = c.rgb;
            float3 normal = normalize(IN.worldNormal);
            float3 dir = normalize(IN.viewDir);
            float val = 1 - (abs(dot(dir, normal)));
            float rim = val * val * _RimValue;
            o.Alpha = c.a * rim;
			o.Emission = c.rgb * tex2D(_MainTex, IN.uv_MainTex).a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}