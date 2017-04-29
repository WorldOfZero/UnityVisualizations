Shader "Custom/Squashing Shader" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0
		_SquishAmount("Squish Amount", Float) = 1.0
		_SquishLimit("Squish Limit", Float) = 0.0
		_Squishyness("Squishyness", Float) = 0.25
		_SquishynessScalar("Squishyness Scalar", Float) = 8
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows vertex:vert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
		half _SquishAmount;
		half _SquishLimit;
		half _Squishyness;
		half _SquishynessScalar;

		void vert(inout appdata_full v) {
			float3 worldPos = mul(unity_ObjectToWorld, v.vertex);

			float squish = 0;
			if (worldPos.y < _SquishLimit) {
				squish = 1;
			}
			else if (worldPos.y < _SquishLimit + _Squishyness) {
				squish = 1 - ((worldPos.y - _SquishLimit) / (_SquishLimit + _Squishyness));
			}
			squish = pow(squish, _SquishynessScalar);
			float3 normal = mul(unity_ObjectToWorld, v.normal);
			normal.y = 0;
			if (!(normal.x == 0 && normal.z == 0)) {
				normal = normalize(normal);
			}
			v.vertex.xyz += normal * squish * _SquishAmount;
			v.vertex.y += squish * 0.5f;

			//float difference = max(worldPos.y, _SquishLimit);
			//v.vertex.y = difference * mul(unity_ObjectToWorld, float3(0, 1, 0));
		}

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
