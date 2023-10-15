﻿Shader "Custom/TestShader"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_BumpMap("NormalMap", 2D) = "bump" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        //#pragma surface surf Standard fullforwardshadows
		#pragma surface surf Lambert noambient

        #pragma target 3.0

        sampler2D _MainTex;
		sampler2D _BumpMap;

        struct Input
        {
            float2 uv_MainTex;
			float2 uv_BumpMap;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
			o.Alpha = c.a;
        }

		float4 HalfLambert(SurfaceOutput s, float3 lightDir, float atten)
		{
			float ndotl = dot(s.Normal, lightDir) * 0.5f + 0.5f;
			ndotl = pow(ndotl, 3);

			float4 final;
			final.rgb = ndotl * s.Albedo * _LightColor0.rgb * atten;
			final.a = s.Alpha;

			return final;
		}
        ENDCG
    }
    FallBack "Diffuse"
}
