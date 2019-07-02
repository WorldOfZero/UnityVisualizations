Shader "World Of Zero/Circle Pixels Matrix"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _Width("Width", Float) = 8
        _Height("Height", Float) = 8
        _Rotation("Rotation", Float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        float _Width;
        float _Height;

        float _Rotation;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        // 2D rotation matrix
        // [ cos, -sin ]
        // [ sin,  cos ]

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float rot = _Rotation * (3.14159 / 180.0);
            float2x2 rotation = float2x2(cos(rot),-sin(rot),sin(rot),cos(rot));

            // Albedo comes from a texture tinted by color
            // Divide UV Space into A grid
            float2 position = IN.uv_MainTex - float2(0.5,0.5);

            position = mul(rotation, position);
            //position += float2(0.5, 0.5);

            position *= float2(_Width, _Height);
            position = ceil(position);
            position /= float2(_Width, _Height);
            // Save the cell position for color lookup
            float2x2 counterRotation = float2x2(cos(-rot),-sin(-rot),sin(-rot),cos(-rot));
            float2 cellPosition = mul(counterRotation, position) + float2(0.5, 0.5);

            // Divide cell into 0-1 uv micro-space
            position -= mul(rotation, IN.uv_MainTex.xy - float2(0.5,0.5));
            position *= float2(_Width, _Height);
            position = float2(1,1) - position;

            // Use micro-space to draw a circle
            float2 circlePosition = float2(0.5, 0.5);
            circlePosition -= position;
            float distance = length(circlePosition);

            fixed4 c = tex2D (_MainTex, cellPosition) * _Color;
            o.Albedo = c.rgb * step(0, (0.5 * c.a) - distance);
            //float2 color = position;
            //o.Albedo = float3(color.x, color.y, 0);
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
