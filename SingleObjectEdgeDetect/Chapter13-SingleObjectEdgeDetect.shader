//简介：在阈值范围内检测边缘，只用单一颜色渲染边缘，不是边缘的剔除不予渲染
//特点：以像素为单位渲染
//用途：物体被选中的边缘高亮效果
//使用原理：在高亮物体的位置，再次渲染它的模型，用此shader，渲染边缘，中间不渲染露出原来的模型
Shader "Unity Shaders Book/Chapter 13/SingleObjectEdgeDetect" {
	Properties
	{

		_EdgeColor("Edge Color", Color) = (0, 0, 0, 1)
		_Threshold("Threshold",Range(0,1)) = 0.5
	}

	SubShader
	{
		CGINCLUDE
		#include "UnityCG.cginc"
		#include "Lighting.cginc"

		fixed4 _EdgeColor;
		fixed _Threshold;

		struct a2v
		{
			float4 vertex : POSITION;
			float3 normal : NORMAL;
		};

		struct v2f {
			float4 pos : SV_POSITION;
			float3 worldNormal : TEXCOORD0;
			float3 worldViewDir : TEXCOORD1;
		};

		v2f vert(a2v v) {
			v2f o;
			o.pos = UnityObjectToClipPos(v.vertex);

			o.worldNormal = mul(v.normal, (float3x3)unity_WorldToObject);
			o.worldViewDir = UnityWorldSpaceViewDir(mul(unity_ObjectToWorld, v.vertex).xyz);
			return o;
		}

		fixed4 fragRobertsCrossDepthAndNormal(v2f i) : SV_Target
		{
			fixed3 worldNormal = normalize(i.worldNormal);
			fixed3 worldViewDir = normalize(i.worldViewDir);
			clip(_Threshold -abs(dot(worldNormal,worldViewDir)));

			return _EdgeColor;
		}


		ENDCG

		Pass
		{
			//ZTest Always Cull Off ZWrite Off

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment fragRobertsCrossDepthAndNormal

			ENDCG
		}
	}
	Fallback Off
}
