// Super simple Unity image effect that reduces horizontal and vertical resolution to a fixed amount.
Shader "Hidden/PixelateImageEffect"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Columns("Pixel Columns", Float) = 64
		_Rows("Pixel Rows", Float) = 64
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
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			float _Columns;
			float _Rows;
			sampler2D _MainTex;

			fixed4 frag (v2f i) : SV_Target
			{
				float2 uv = i.uv;
				uv.x *= _Columns;
				uv.y *= _Rows;
				uv.x = round(uv.x);
				uv.y = round(uv.y);
				uv.x /= _Columns;
				uv.y /= _Rows;
				fixed4 col = tex2D(_MainTex, uv);
				return col;
			}
			ENDCG
		}
	}
}
