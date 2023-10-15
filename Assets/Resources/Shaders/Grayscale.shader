Shader "Custom/Grayscale"
{
	Properties
	{
		_MainTex("MainTexture", 2D) = "white" {}
	}
		SubShader
		{
			Pass
			{
				Tags
				{
					"LightMode" = "ForwardBase"
					"PassFlags" = "OnlyDirectional"
				}

				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma multi_compile_fwdbase

				#include "UnityCG.cginc"
				#include "Lighting.cginc"
				#include "AutoLight.cginc"

				struct appdata
				{
					float4 vertex : POSITION;
					float4 uv : TEXCOORD0;
					float3 normal : NORMAL;
				};

				struct v2f
				{
					float4 pos : SV_POSITION;
					float3 worldNormal : NORMAL;
					float2 uv : TEXCOORD0;
					float3 viewDir : TEXCOORD1;
					SHADOW_COORDS(2)
				};

				sampler2D _MainTex;
				float4 _MainTex_ST;

				v2f vert(appdata v)
				{
					v2f o;
					o.pos = UnityObjectToClipPos(v.vertex);
					o.worldNormal = UnityObjectToWorldNormal(v.normal);
					o.viewDir = WorldSpaceViewDir(v.vertex);
					o.uv = TRANSFORM_TEX(v.uv, _MainTex);
					TRANSFER_SHADOW(o)
					return o;
				}

				float4 frag(v2f i) : SV_Target
				{
					fixed4 texColor = tex2D(_MainTex, i.uv);
					texColor = (0.299 *texColor.r) + (0.587 * texColor.g) + (0.114 * texColor.b);

					return texColor;
				}
				ENDCG
			}

			// Shadow casting support.
			UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
		}
}