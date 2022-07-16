Shader "Mandelbrot/Mandelbrot"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Area("Area", vector) = (0, 0, 4, 4)
        _Angle("Angle", range(-3.14, 3.14)) = 0
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
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float4 _Area;
            float _Angle;
            sampler2D _MainTex;

            float2 rotation(float2 position, float2 pivot, float a)
            {
                float s = sin(a);
                float c = cos(a);
                
                position -= pivot;
                position = float2(position.x * c - position.y * s, position.x * s + position.y * c);
                position += pivot;

                return position;
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
                float2 c =  _Area.xy + (i.uv - .5) * _Area.zw; // Start position initialized to uv coordinate
                c = rotation(c, _Area.xy, _Angle);
                
                float2 z; // Keeping track of pixel
                float iterator; // Keep track of iteration

                // Mandelbrot Algorithm here:
                for (iterator = 0; iterator < 255; iterator++)
                {
                    z = float2( (z.x * z.x) - (z.y * z.y), 2 * z.x * z.y ) + c;

                    if (length(z) > 2) // Breaking the loop
                        break;
                }
                
                return iterator / 255;
            }
            ENDCG
        }
    }
}
