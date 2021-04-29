
    Shader "ShaderMan/MyShader"
	{
	Properties{
	
	}
	SubShader
	{
	Tags { "RenderType" = "Transparent" "Queue" = "Transparent" }
	Pass
	{
	ZWrite Off
	Blend SrcAlpha OneMinusSrcAlpha
	CGPROGRAM
	#pragma vertex vert
	#pragma fragment frag
	#include "UnityCG.cginc"
			
    

    float4 vec4(float x,float y,float z,float w){return float4(x,y,z,w);}
    float4 vec4(float x){return float4(x,x,x,x);}
    float4 vec4(float2 x,float2 y){return float4(float2(x.x,x.y),float2(y.x,y.y));}
    float4 vec4(float3 x,float y){return float4(float3(x.x,x.y,x.z),y);}


    float3 vec3(float x,float y,float z){return float3(x,y,z);}
    float3 vec3(float x){return float3(x,x,x);}
    float3 vec3(float2 x,float y){return float3(float2(x.x,x.y),y);}

    float2 vec2(float x,float y){return float2(x,y);}
    float2 vec2(float x){return float2(x,x);}

    float vec(float x){return float(x);}
    
    

	struct VertexInput {
    float4 vertex : POSITION;
	float2 uv:TEXCOORD0;
    float4 tangent : TANGENT;
    float3 normal : NORMAL;
	//VertexInput
	};
	struct VertexOutput {
	float4 pos : SV_POSITION;
	float2 uv:TEXCOORD0;
	//VertexOutput
	};
	
	
	VertexOutput vert (VertexInput v)
	{
	VertexOutput o;
	o.pos = UnityObjectToClipPos (v.vertex);
	o.uv = v.uv;
	//VertexFactory
	return o;
	}
    
    // by srtuss, 2013
// I love complex machines! :)
// Still could use some optimisation.

// * improved gears
// * improved camera movement

float hash(float x)
{
	return frac(sin(x) * 43758.5453);
}

float2 hash(float2 p)
{
    p = vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)));
	return frac(sin(p) * 43758.5453);
}

// simulates a resonant lowpass filter
float mechstep(float x, float f, float r)
{
	float fr = frac(x);
	float fl = floor(x);
	return fl + pow(fr, 0.5) + sin(fr * f) * exp(-fr * 3.5) * r;
}

// voronoi cell id noise
float3 voronoi(in float2 x)
{
	float2 n = floor(x);
	float2 f = frac(x);

	float2 mg, mr;
	
	float md = 8.0;
	[unroll(100)]
for(int j = -1; j <= 1; j ++)
	{
		[unroll(100)]
for(int i = -1; i <= 1; i ++)
		{
			float2 g = vec2(float(i),float(j));
			float2 o = hash(n + g);
			float2 r = g + o - f;
			float d = max(abs(r.x), abs(r.y));
			
			if(d < md)
			{
				md = d;
				mr = r;
				mg = g;
			}
		}
	}
	
	return vec3(n + mg, mr);
}

float2 rotate(float2 p, float a)
{
	return vec2(p.x * cos(a) - p.y * sin(a), p.x * sin(a) + p.y * cos(a));
}

float stepfunc(float a)
{
	return step(a, 0.0);
}

float fan(float2 p, float2 at, float ang)
{
	p -= at;
	p *= 3.0;
	
	float v = 0.0, w, a;
	float le = length(p);
	
	v = le - 1.0;
	
	if(v > 0.0)
		return 0.0;
	
	a = sin(atan2( p.x,p.y) * 3.0 + ang);
	
	w = le - 0.05;
	v = max(v, -(w + a * 0.8));
	
	w = le - 0.15;
	v = max(v, -w);
	
	return stepfunc(v);
}

float gear(float2 p, float2 at, float teeth, float size, float ang)
{
	p -= at;
	float v = 0.0, w;
	float le = length(p);
	
	w = le - 0.3 * size;
	v = w;
	
	w = sin(atan2( p.x,p.y) * teeth + ang);
	w = smoothstep(-0.7, 0.7, w) * 0.1;
	v = min(v, v - w);
	
	w = le - 0.05;
	v = max(v, -w);
	
	return stepfunc(v);
}

float car(float2 p, float2 at)
{
	p -= at;
	float v = 0.0, w;
	w = length(p + vec2(-0.05, -0.31)) - 0.03;
	v = w;
	w = length(p + vec2(0.05, -0.31)) - 0.03;
	v = min(v, w);
	
	float2 box = abs(p + vec2(0.0, -0.3 - 0.07));
	w = max(box.x - 0.1, box.y - 0.05);
	v = min(v, w);
	return stepfunc(v);
}

float layerA(float2 p, float seed)
{
	float v = 0.0, w, a;
	
	float si = floor(p.y);
	float sr = hash(si + seed * 149.91);
	float2 sp = vec2(p.x, fmod(p.y, 4.0));
	float strut = 0.0;
	strut += step(abs(sp.y), 0.3);
	strut += step(abs(sp.y - 0.2), 0.1);
	
	float st = _Time.y + sr;
	float ct = fmod(st * 3.0, 5.0 + sr) - 2.5;
	
	v = step(2.0, abs(voronoi(p + vec2(0.35, seed * 194.9)).x));
	
	w = length(sp - vec2(-2.0, 0.0)) - 0.8;
	v = min(v, 1.0 - step(w, 0.0));
	
	
	a = st;
	w = fan(sp, vec2(2.5, 0.65), a * 40.0);
	v = min(v, 1.0 - w);
	
	
	return v;
}

float layerB(float2 p, float seed)
{
	float v = 0.0, w, a;
	
	float si = floor(p.y / 3.0) * 3.0;
	float2 sp = vec2(p.x, fmod(p.y, 3.0));
	float sr = hash(si + seed * 149.91);
	sp.y -= sr * 2.0;
	
	float strut = 0.0;
	strut += step(abs(sp.y), 0.3);
	strut += step(abs(sp.y - 0.2), 0.1);
	
	float st = _Time.y + sr;
	
	float cs = 2.0;
	if(hash(sr) > 0.5)
		cs *= -1.0;
	float ct = fmod(st * cs, 5.0 + sr) - 2.5;

	
	v = step(2.0, abs(voronoi(p + vec2(0.35, seed * 194.9)).x) + strut);
	
	w = length(sp - vec2(-2.3, 0.6)) - 0.15;
	v = min(v, 1.0 - step(w, 0.0));
	w = length(sp - vec2(2.3, 0.6)) - 0.15;
	v = min(v, 1.0 - step(w, 0.0));
	
	if(v > 0.0)
		return 1.0;
	
	
	w = car(sp, vec2(ct, 0.0));
	v = w;
	
	if(hash(si + 81.0) > 0.5)
		a = mechstep(st * 2.0, 20.0, 0.4) * 3.0;
	else
		a = st * (sr - 0.5) * 30.0;
	w = gear(sp, vec2(-2.0 + 4.0 * sr, 0.5), 8.0, 1.0, a);
	v = max(v, w);
	
	w = gear(sp, vec2(-2.0 + 0.65 + 4.0 * sr, 0.35), 7.0, 0.8, -a);
	v = max(v, w);
	if(hash(si - 105.13) > 0.8)
	{
		w = gear(sp, vec2(-2.0 + 0.65 + 4.0 * sr, 0.35), 7.0, 0.8, -a);
		v = max(v, w);
	}
	if(hash(si + 77.29) > 0.8)
	{
		w = gear(sp, vec2(-2.0 - 0.55 + 4.0 * sr, 0.30), 5.0, 0.5, -a + 0.7);
		v = max(v, w);
	}
	
	return v;
}


    
    
	fixed4 frag(VertexOutput vertex_output) : SV_Target
	{
	
	float2 uv = vertex_output.uv / 1;
	uv = uv * 2.0 - 1.0;
	float2 p = uv;
	p.x *= 1 / 1;
	
	float t = _Time.y;
	
	float2 cam = vec2(sin(t) * 0.2, t);
	
	// for future use
	/*float quake = exp(-frac(t) * 5.0) * 0.5;
	if(quake > 0.001)
	{
		cam.x += (hash(t) - 0.5) * quake;
		cam.y += (hash(t - 118.29) - 0.5) * quake;
	}*/
	
	p = rotate(p, sin(t) * 0.02);
	
	float2 o = vec2(0.0, t);
	float v = 0.0, w;
	
	
	float z = 3.0 - sin(t * 0.7) * 0.1;
	[unroll(100)]
for(int i = 0; i < 5; i ++)
	{
		float f = 1.0;
		
		float zz = 0.3 + z;
		
		f = zz * 2.0 * 0.9;
		
		
		if(i == 3 || i == 1)
			w = layerA(vec2(p.x, p.y) * f + cam, float(i));
		else
			w = layerB(vec2(p.x, p.y) * f + cam, float(i));
		v = lerp(v, exp(-abs(zz) * 0.3 + 0.1), w);
		
		
		z -= 0.6;
	}
	
	
	
	
	v = 1.0 - v;// * pow(1.0 - abs(uv.x), 0.1);
	
	return vec4(v, v, v, 1.0);

	}
	ENDCG
	}
  }
  }
