Shader "Hidden/NightVisionEffectShader"
{
	Properties
	{
		_Color("Color", Color) = (0,1,0,1)
		_MainTex ("Texture", 2D) = "white" {}
		_Range("Range", Float) = 0.01
		_ColorMultiplier("Color Multiplier", Float) = 1
		_ColorMask("Color Mask", 2D) = "white" {}
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float2 uv_depth : TEXCOORD1;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.uv;
				o.uv_depth = v.uv;
				return o;
			}

			sampler2D _MainTex;
			sampler2D _ColorMask;
			sampler2D_float _CameraDepthTexture;
			float _Range;
			float _ColorMultiplier;
			fixed4 _Color;

			fixed lum(fixed3 color) {
				//Source: http://stackoverflow.com/questions/596216/formula-to-determine-brightness-of-rgb-color
				return 0.299*color.r + 0.587*color.g + 0.114*color.b;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				float depth = DecodeFloatRG(tex2D(_CameraDepthTexture, i.uv));
				float linearDepth = Linear01Depth(depth); // 1 is close, 0 is far after being flipped
				linearDepth = max(0, (_Range - linearDepth) / _Range);
				fixed4 col = tex2D(_MainTex, i.uv);
				fixed4 mask = tex2D(_ColorMask, i.uv);
				// just invert the colors
				fixed color = (lum(col) * _ColorMultiplier) + linearDepth;
				return _Color * color  * mask;
			}
			ENDCG
		}
	}
}
