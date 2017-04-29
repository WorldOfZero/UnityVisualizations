// Developed as a part of the Asylum Jam 2015. Super trippy trace-like effect.
Shader "Custom/TracerShader" {
	Properties {
		_EchoFrequency("Echo Frequency", Float) = 1
		_EchoLocation("Echo Location", Vector) = (0,0,0,0)
		_MaxDistance("Max Echo Distance", Float) = 25
		_EchoVelocity("Echo Velocity", Float) = 25
	}
	SubShader {
		Tags { "RenderType" = "Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows
		#include "UnityCG.cginc"
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
			float3 worldPos;
			float4 vert_Color : COLOR;
			//float3 _Time;
		};

		half4 _EchoLocation;
		half _EchoVelocity;
		half _EchoFrequency;
		half _MaxDistance;
		fixed4 _Color;

		void surf (Input IN, inout SurfaceOutputStandard o) {
			half phase = _Time.x * _EchoVelocity;
			half3 delta = IN.worldPos - _EchoLocation.xyz;
			half delta_mag = 1 - (length(delta)/_MaxDistance);
			half strength = sin(delta_mag * _MaxDistance * _EchoFrequency + phase);
			strength = (abs(strength) - 0.99) * 100;
			if (strength < 0) strength = 0;
			if (delta_mag < 0) delta_mag = 0;

			// Albedo comes from a texture tinted by color
			fixed4 c = IN.vert_Color * strength * pow(delta_mag, 10);
			o.Albedo = half3(1,1,1);
			o.Emission = c.rgb * 4;
			// Metallic and smoothness come from slider variables
			o.Metallic = 0;
			o.Smoothness = 0;
			o.Alpha = 1;
		}
		ENDCG
	} 
	FallBack "Standard"
}
