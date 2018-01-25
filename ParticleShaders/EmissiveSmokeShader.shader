Shader "Custom/Emissive Smoke" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGBA)", 2D) = "white" {}
		[HDR]_EmissionColor ("Emission Color", Color) = (1,0,0,1)
		_EmissionLocation ("Emission Location", Vector) = (0,0,0,0)
		_EmissionRange ("Emission Range", Float) = 10
	}
	SubShader {
		Tags { "Queue"="Transparent" "RenderType" = "Transparent" }
		LOD 200
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows alpha:fade

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
			float4 vertColor : COLOR;
			float3 worldPos;
		};

		fixed4 _Color;
		float4 _EmissionColor;
		float4 _EmissionLocation;
		float _EmissionRange;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_CBUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_CBUFFER_END

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color * IN.vertColor;

			float distanceFromEmission = clamp((_EmissionRange - length(IN.worldPos.xyz - _EmissionLocation.xyz)) / _EmissionRange, 0, 1);
			fixed4 emission = (_EmissionColor * c.a * distanceFromEmission);

			o.Albedo = c.rgb;
			o.Emission = emission.rgb;
			// Metallic and smoothness come from slider variables
			o.Metallic = 0;
			o.Smoothness = 0;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
