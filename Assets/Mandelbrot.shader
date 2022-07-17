Shader "Mandelbrot/Mandelbrot"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Area("Area", vector) = (0, 0, 4, 4)
        _Angle("Angle", range(-3.14, 3.14)) = 0
        _MaxIterator("MaxIterator", range(4, 1024)) = 255
        _Color("Color", range(0, 1)) = .5
        _Repeat("Repeat", float) = 1
        _Speed("Speed", float) = 1
        _Symmetry("Symmetry", range(0, 1)) = 1
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
            float _Angle, _MaxIterator, _Color, _Repeat, _Speed, _Symmetry;
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
                float2 uv = i.uv - .5;
                uv = abs(uv);
                uv = rotation(uv, 0, .25 * 3.1415);
                uv = abs(uv);

                uv = lerp(i.uv - .5, uv, _Symmetry); 
                
                float2 c =  _Area.xy + uv * _Area.zw; // Start position initialized to uv coordinate
                c = rotation(c, _Area.xy, _Angle);

                float r = 20; // Escape radius
                float r2 = r * r;
                
                float2 z ,zPrev; // Keeping track of pixel
                float iterator; // Keep track of iteration

                // Mandelbrot Algorithm here:
                for (iterator = 0; iterator < _MaxIterator; iterator++)
                {
                    zPrev = rotation(z, 0, _Time.y);
                    z = float2( (z.x * z.x) - (z.y * z.y), 2 * z.x * z.y ) + c;

                    if (dot(z, zPrev) > r2) // Breaking the loop
                        break;
                }

                if (iterator >= _MaxIterator) return 0;

                float distance = length(z); // Distance from origin
                float fracIterator = (distance - r) / (r2 - r); // Linear interpolation
                fracIterator = log2(log(distance) / log(r)); // Double exponential interpolation

                // iterator -= fracIterator;
                
                float m = sqrt(iterator / _MaxIterator);
                float4 color = sin(float4(.3, .45, .65, 1) * m * 20) * .5 + .5; // procedural colors
                color = tex2D(_MainTex, float2(m * _Repeat + _Time.y * _Speed, _Color));

                float angle = atan2(z.x, z.y); // -pi and pi
                // if (i.uv.x > .5)
                color *= smoothstep(3, 0, fracIterator);

                color *= 1 + sin(angle * 2 + _Time.y * 4) * .2;
                return color;
            }
            ENDCG
        }
    }
}
