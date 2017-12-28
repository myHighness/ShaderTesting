// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Unlit/SpineWave"
{
	Properties
	{
		_MainColor ("Color", Color) = (1.0,0.0,1.0,1.0)
		_Speed ("Wave Speed", Float) = 1
		_Amount ("Wave Amount", Float) = 1
		_Height ("Wave Height", Float) = 1
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

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

			fixed4 _MainColor;
			float _Speed;
			float _Amount;
			float _Height;						
			
			v2f vert (appdata v)
			{
				v2f o;
				float3 worldPos = mul (unity_ObjectToWorld, v.vertex).xyz;
				v.vertex.y += sin(_Time.z * _Speed + (worldPos.x * worldPos.z * _Amount)) * _Height;
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				return _MainColor;
			}
			ENDCG
		}
	}
}
