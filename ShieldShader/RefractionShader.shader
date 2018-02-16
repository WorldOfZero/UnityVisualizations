// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/RefractionShader" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_RefractionAmount ("Refraction Amount", Float) = 0.1
		_PointColor("Point Color (RGB)", Color) = (1,0,0,1)
		_ImpactSize("Smoothness", Float) = 0.5
		_ImpactRingRefraction("Impact Ring Refraction Amount", Float) = 1
	}
	SubShader {
		Tags { "Queue" = "Transparent" }
		LOD 200
		
		GrabPass { "_GrabTexture" }

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows vertex:vert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _GrabTexture;

		struct Input {
			float4 grabUV;
			float4 refract;
			float3 worldPos;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
		float _RefractionAmount;
		float _ImpactRingRefraction;

		fixed4 _PointColor;

		float _ImpactSize;

		int _PointsSize;
		fixed4 _Points[50];

		void vert(inout appdata_full i, out Input o) {
			float4 pos = UnityObjectToClipPos(i.vertex);
			o.grabUV = ComputeGrabScreenPos(pos);
			o.refract = float4(i.normal,0) * _RefractionAmount;
			o.worldPos = pos;
		}

		void surf (Input IN, inout SurfaceOutputStandard o) {

			fixed emissive = 0;

			float3 positionChange = float3(0, 0, 0);
			float3 objPos = mul(unity_WorldToObject, float4(IN.worldPos, 1)).xyz;
			for (int i = 0; i < _PointsSize; ++i) {
				float amount = max(0, frac(1.0 - max(0, (_Points[i].w * _ImpactSize) - distance(_Points[i].xyz, objPos.xyz)) / _ImpactSize) * (1 - _Points[i].w));
				emissive += amount;
				positionChange += amount * normalize(objPos.xyz - _Points[i].xyz);
			}

			float4 screenRefraction = UnityObjectToClipPos(float4(positionChange, 1));
			screenRefraction = normalize(screenRefraction) * _ImpactRingRefraction;

			// Albedo comes from a texture tinted by color
			fixed4 c = tex2Dproj (_GrabTexture, UNITY_PROJ_COORD(IN.grabUV + IN.refract + float4(screenRefraction.xy, 0, 0))) * _Color;
			o.Albedo = c.rgb;
			o.Emission = emissive * screenRefraction; // _PointColor;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
