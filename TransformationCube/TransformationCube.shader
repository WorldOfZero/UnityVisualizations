// Shader developed for the Transformation Matrices Shader video on World of Zero.
// https://www.youtube.com/watch?v=VzhxginBhdc
// Developed for Boxes/Cubes but should work anywhere
Shader "Custom/Fancy Box Shader" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_OriginOffset ("Offset", Float) = 0.0
		_Offset("Offset", Vector) = (0,0,0,0) // The translation of the objects vertices
		_Skew ("Skew", Vector) = (0,0,0,0) // Skews the vertices based upon the difference in the Y coordinate
		_Rotation ("Rotation", Vector) = (0,0,0,0) // Rotates the Offset and Skewed mesh by the given X, Y and Z angles
	}
	SubShader {
		Tags { "RenderType"="Opaque" "DisableBatching" = "true" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types. Disable lightmapping so transformation doesn't cause artifacts.
		#pragma surface surf Standard vertex:vert addshadow fullforwardshadows nolightmap

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
		float _OriginOffset;
		float4 _Offset;
		float4 _Skew;
		float4 _Rotation;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_CBUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_CBUFFER_END

		/*
			Rotational Matrix by Axis. Additional reference: en.wikipedia.org/wiki/Transformation_matrix
			D: angle of rotation

			X
			[1  0  0  0]
			[0 cos(D) -sin(D) 0]
			[0 sin(D) cos(D) 0]
			[0 0 0 1]

			Y
			[cos(D) 0 sin(D) 0]
			[0 1 0 0]
			[-sin(D) 0 cos(D) 0]
			[0 0 0 1]

			Z
			[cos(D) -sin(D) 0 0]
			[sin(D) cos(D) 0 0]
			[0 0 0 0]
			[0 0 0 1]

		*/
		float3 rotationX(float3 vertex, float rotation) {
			float4 vert = float4(vertex, 1);
			float4x4 mat;
			mat[0] = float4(1, 0, 0, 0);
			mat[1] = float4(0, cos(rotation), -sin(rotation), 0);
			mat[2] = float4(0, sin(rotation), cos(rotation), 0);
			mat[3] = float4(0, 0, 0, 1);
			return mul(mat, vert).xyz;
		}

		float3 rotationY(float3 vertex, float rotation) {
			float4 vert = float4(vertex, 1);
			float4x4 mat;
			mat[0] = float4(cos(rotation), 0, sin(rotation), 0);
			mat[1] = float4(0, 1, 0, 0);
			mat[2] = float4(-sin(rotation), 0, cos(rotation), 0);
			mat[3] = float4(0, 0, 0, 1);
			return mul(mat, vert).xyz;
		}		
		
		float3 rotationZ(float3 vertex, float rotation) {
			float4 vert = float4(vertex, 1);
			float4x4 mat;
			mat[0] = float4(cos(rotation), -sin(rotation), 0, 0);
			mat[1] = float4(sin(rotation), cos(rotation), 0, 0);
			mat[2] = float4(0, 0, 1, 0);
			mat[3] = float4(0, 0, 0, 1);
			return mul(mat, vert).xyz;
		}

		void vert(inout appdata_full v) {
			float modifier = v.vertex.y - _OriginOffset;
			v.vertex.xyz += _Offset;
			v.vertex.xyz += _Skew.xyz * modifier;
			v.vertex.xyz = rotationX(v.vertex.xyz, _Rotation.x * modifier);
			v.vertex.xyz = rotationY(v.vertex.xyz, _Rotation.y * modifier);
			v.vertex.xyz = rotationZ(v.vertex.xyz, _Rotation.z * modifier);
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