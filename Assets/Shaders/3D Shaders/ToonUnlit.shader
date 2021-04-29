Shader "HCF/3D/Toon Lit" {
	Properties {
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_Tint("Tint", Color) = (1, 1, 1, 1)
		[Header(Lighting)]
		[Toggle]
		_UseRampText("Use Ramp Texture", Float) = 0
		[NoScaleOffset]
		_RampTex("Ramp Texture (Greyscale)", 2D) = "white" {}
		[IntRange]
		_StepAmount("Shadow Steps (if no ramp tex)", Range(1, 16)) = 2
		_StepWidth("Step Size (if no ramp tex)", Range(0.05, 1)) = 0.25
		[Toggle]
		_VertexColors("Display vertex colors", Float) = 0
		[Toggle]
		_MaterialShadowColor("Shadow Color From Material", Float) = 1
		[HDR]
		_ShadowTint("Shadow Color", Color) = (0, 0, 0, 1)
		[Header(Specular)]
		[Toggle]
		_Specular("Enable Specular", Float) = 1
		_SpecularSize("Specular Size", Range(0, 1)) = 0.1
		_SpecularFalloff("Specular Falloff", Range(0, 2)) = 1
		_SpecularColor("Specular Color", Color) = (1, 1, 1, 1)
		[Header(Rim Light)]
		[Toggle]
		_RimLight("Enable Rim Light", Float) = 0
		_RimColor("Rim color", Color) = (1, 1, 1, 1)
		_RimAmount("Rim Amount", Range(0, 1)) = 0.716
		_RimExp("Rim Exponent", Range(0, 1)) = 0.1
	}
	SubShader {
		Tags {
			"RenderType" = "Opaque"
			"Queue" = "Geometry"
		}
		LOD 200

		CGPROGRAM
		// fullforwardshadows makes sure unity adds the shadow passes the shader might need
		#pragma surface surf ToonStep fullforwardshadows
		#pragma target 3.0
		#pragma shader_feature_local _USERAMPTEXT_ON
		#pragma shader_feature_local _VERTEXCOLORS_ON
		#pragma shader_feature_local _MATERIALSHADOWCOLOR_ON
		#pragma shader_feature_local _SPECULAR_ON
		#pragma shader_feature_local _RIMLIGHT_ON

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
			#if defined(_VERTEXCOLORS_ON)
			float4 color : COLOR;
			#endif
		};

		struct ToonSurfaceOutput{
			fixed3 Albedo;
			half3 Emission;
			#if defined(_SPECULAR_ON)
			fixed3 Specular;
			#endif
			fixed Alpha;
			fixed3 Normal;
		};

		fixed4 _Tint;
		#if defined(_MATERIALSHADOWCOLOR_ON)
		float3 _ShadowTint;
		#endif
		#if defined(_SPECULAR_ON)
		fixed3 _SpecularColor;
		#endif

		void surf(Input IN, inout ToonSurfaceOutput o) {
			fixed4 col = tex2D(_MainTex, IN.uv_MainTex) * _Tint;
			#if defined(_VERTEXCOLORS_ON)
			col *= IN.color;
			#endif
			o.Albedo = col.rgb;

			#if defined(_MATERIALSHADOWCOLOR_ON)
			o.Emission = col.rgb * _ShadowTint;
			#else
			o.Emission = col.rgb * UNITY_LIGHTMODEL_AMBIENT;
			#endif
			
			#if defined(_SPECULAR_ON)
			o.Specular = _SpecularColor;
			#endif
		}

		#if defined(_USERAMPTEXT_ON)
		sampler2D _RampTex;
		#else
		int _StepAmount;
		float _StepWidth;
		#endif
		#if defined(_SPECULAR_ON)
		float _SpecularSize, _SpecularFalloff;
		#endif
		#if defined(_RIMLIGHT_ON)
		float4 _RimColor;
		float _RimAmount, _RimExp;
		#endif

		float4 LightingToonStep(ToonSurfaceOutput s, float3 lightDir, half3 viewDir, float shadowAttenuation) {
			// Copied from toonlit standard shader
			#ifndef USING_DIRECTIONAL_LIGHT
			lightDir = normalize(lightDir);
			#endif

			float nDotL = dot(s.Normal, lightDir);
			#if defined(_USERAMPTEXT_ON)
			nDotL = nDotL * 0.5 + 0.5;
			float intensity = tex2D(_RampTex, float2(nDotL, nDotL)).r;
			#else
			// strech values so each whole value is one step
			nDotL /= _StepWidth;
			// make steps harder
			float intensity = floor(nDotL);

			// fwidth computes difference over quad-pixels
			// This gives a bit of smoother lines as it lerps over single pixel
			// It's fine that intensity goes lower than 0, since that's just shadow
			float nDotLDelta = fwidth(nDotL);
			// calculate smoothing in first pixels of the steps and add smoothing to step, raising it by one step
			// (that's fine because we used floor previously and we want everything to be the value above the floor value, 
			// for example 0 to 1 should be 1, 1 to 2 should be 2 etc...)
			float smoothing = smoothstep(0, nDotLDelta, frac(nDotL));
			intensity += smoothing;
			// bring the light intensity back into a range where we can use it for color
			// and clamp it so it doesn't do weird stuff below 0 / above one
			intensity /= _StepAmount;
			intensity = saturate(intensity);
			#endif

			#if defined(USING_DIRECTIONAL_LIGHT)
			float attenuationDelta = fwidth(shadowAttenuation) * 0.5;
			float shadow = smoothstep(0.5 - attenuationDelta, 0.5 + attenuationDelta, shadowAttenuation);
			#else
			float attenuationDelta = fwidth(shadowAttenuation);
			float shadow = smoothstep(0, attenuationDelta, shadowAttenuation);
			#endif
			intensity *= shadow;
			float3 lightCol = intensity * _LightColor0.rgb;
			
			#if defined(_SPECULAR_ON)
			// calculate how much the surface points points towards the reflection direction
			float3 reflectionDirection = reflect(lightDir, s.Normal);
			float specular = dot(viewDir, -reflectionDirection);
			// make specular highlight all off towards outside of model
			float specularFalloff = dot(viewDir, s.Normal);
			specularFalloff = pow(specularFalloff, _SpecularFalloff);
			specular *= specularFalloff;
			// make specular intensity with a hard corner
			float specularDelta = fwidth(specular);
			float specularIntensity = smoothstep(1 - _SpecularSize, 1 - _SpecularSize + specularDelta, specular);
			// factor inshadows
			specularIntensity *= shadow;
			#endif

			#if defined(_RIMLIGHT_ON)
			float rimDot = 1 - dot(viewDir, s.Normal);
			float rimIntensity = rimDot * pow(nDotL, _RimExp);
			rimIntensity = smoothstep(_RimAmount - 0.01, _RimAmount + 0.01, rimIntensity);
			float4 rim = rimIntensity * _RimColor;
			lightCol += rim;
			#endif

			float4 color;
			color.rgb = s.Albedo * lightCol;
			#if defined(_SPECULAR_ON)
			color.rgb = lerp(color.rgb, s.Specular, saturate(specularIntensity));
			#endif
			color.a = s.Alpha;
			return color;
		}
		ENDCG
	}
	FallBack "Standard"
}