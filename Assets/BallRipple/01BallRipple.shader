﻿Shader "Unlit/BallRipple"
{
	Properties
	{
		_MainColor ("Color A", Color) = (0.5,0.5,0.5,1.0)	
		_SecondColor ("Color B", Color) = (0.0, 1.0, 0.0, 1.0)
		_Amount ("Extrusion Amount", Range(-1.0,1.0)) = 0
		_Frequency ("Frequency", Range(10,100)) = 30
		_ScrollSpeed ("Scroll Speed", Range(0,10)) = 0.5
	}
		
		
	SubShader
	{
		Tags { "RenderType"="Opaque" "LightMode"="ForwardBase" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			#include "UnityLightingCommon.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float4 color : COLOR;
				float4 diff : COLOR1;
			};

			float4 _MainColor;
			float4 _SecondColor;
			float _Amount;
			float _Frequency;
			float _DisplAmount;
			float _ScrollSpeed;
			
			float wave(float c) {
			    c = (sin(c * _Frequency) + 1) / 2;
			    return c;
			}
			
			v2f vert (appdata v)
			{ 
				v2f o;
			    o.uv = v.uv;
                float t = v.uv.y; 	
                float a = t + (_Time.x * _ScrollSpeed);
			    float waveVal = wave(a);
			    o.color = waveVal;
				v.vertex.xyz += v.normal * _Amount * waveVal ;
				
				o.vertex = UnityObjectToClipPos(v.vertex);
				
				 // get vertex normal in world space
                half3 worldNormal = UnityObjectToWorldNormal(v.normal);
                // dot product between normal and light direction for
                // standard diffuse (Lambert) lighting
                half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));
                // factor in the light color
                o.diff = nl * _LightColor0;
                o.diff.rgb += ShadeSH9(half4(worldNormal,1));
                
			    return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
			    float4 gradient = lerp(_SecondColor, _MainColor,  i.uv.y);
			    gradient *= i.diff;
			    
			    return gradient;		    
			}
			ENDCG
		}
	}
}
