// Built as part of World of Zero: https://youtu.be/AK8oV4BzrW4
Shader "Custom/HeightShader" {
	Properties {
		[HDR]_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_ProjectionHeight ("Projection Height", Float) = 1
		_ProjectionRange ("Projection Padding", Float) = 0.05
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
			float3 worldPos;
		};

		fixed4 _Color;
		half _ProjectionRange;
		half _ProjectionHeight;

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			float height = tex2D (_MainTex, IN.uv_MainTex).r * _ProjectionHeight;
			float heightDist = height - IN.worldPos.y;
			clip(_ProjectionRange - abs(heightDist));
			o.Albedo = float3(0, 0, 0);
			o.Emission = _Color;
			o.Alpha = 1;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
