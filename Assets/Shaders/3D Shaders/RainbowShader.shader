// Shader created with Shader Forge v1.38 
// Shader Forge (c) Freya Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:4013,x:33319,y:32912,varname:node_4013,prsc:2|emission-9006-OUT,alpha-1231-OUT,refract-971-OUT,voffset-5198-OUT;n:type:ShaderForge.SFN_Time,id:239,x:31831,y:32557,varname:node_239,prsc:2;n:type:ShaderForge.SFN_Divide,id:3654,x:32033,y:32712,varname:node_3654,prsc:2|A-239-T,B-1263-OUT;n:type:ShaderForge.SFN_Vector1,id:1263,x:31831,y:32732,varname:node_1263,prsc:2,v1:4;n:type:ShaderForge.SFN_Slider,id:195,x:32640,y:32483,ptovrint:False,ptlb:Scale,ptin:_Scale,varname:node_195,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.3560196,max:1;n:type:ShaderForge.SFN_Multiply,id:9640,x:33056,y:32558,varname:node_9640,prsc:2|A-195-OUT,B-3188-OUT,C-3287-OUT;n:type:ShaderForge.SFN_NormalVector,id:3188,x:32718,y:32559,prsc:2,pt:False;n:type:ShaderForge.SFN_Vector1,id:12,x:32450,y:32914,varname:node_12,prsc:2,v1:0.5;n:type:ShaderForge.SFN_Append,id:6642,x:33409,y:33758,varname:node_6642,prsc:2|A-1415-OUT,B-5471-OUT;n:type:ShaderForge.SFN_Vector1,id:1415,x:33224,y:33705,varname:node_1415,prsc:2,v1:0;n:type:ShaderForge.SFN_Time,id:8838,x:33057,y:33758,varname:node_8838,prsc:2;n:type:ShaderForge.SFN_Sin,id:5471,x:33224,y:33779,varname:node_5471,prsc:2|IN-8838-T;n:type:ShaderForge.SFN_OneMinus,id:5518,x:32589,y:33779,varname:node_5518,prsc:2|IN-6310-OUT;n:type:ShaderForge.SFN_Distance,id:6310,x:32415,y:33779,varname:node_6310,prsc:2|A-5423-UVOUT,B-7619-OUT;n:type:ShaderForge.SFN_Vector2,id:7619,x:32204,y:33861,varname:node_7619,prsc:2,v1:0.5,v2:0.5;n:type:ShaderForge.SFN_Set,id:9308,x:33239,y:32558,varname:VertexScale,prsc:2|IN-9640-OUT;n:type:ShaderForge.SFN_TexCoord,id:5423,x:32204,y:33718,varname:node_5423,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Set,id:5220,x:32758,y:33779,varname:OpacityMask,prsc:2|IN-5518-OUT;n:type:ShaderForge.SFN_ComponentMask,id:6548,x:32101,y:32974,varname:node_6548,prsc:2,cc1:0,cc2:-1,cc3:-1,cc4:-1|IN-6226-UVOUT;n:type:ShaderForge.SFN_Hue,id:4416,x:32821,y:32975,varname:node_4416,prsc:2|IN-2846-OUT;n:type:ShaderForge.SFN_Sin,id:4363,x:32476,y:32712,varname:node_4363,prsc:2|IN-1156-OUT;n:type:ShaderForge.SFN_Distance,id:2846,x:32640,y:32975,varname:node_2846,prsc:2|A-12-OUT,B-1744-OUT;n:type:ShaderForge.SFN_TexCoord,id:6226,x:31826,y:32975,varname:node_6226,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Multiply,id:1156,x:32241,y:32712,varname:node_1156,prsc:2|A-2561-OUT,B-3654-OUT;n:type:ShaderForge.SFN_Pi,id:2561,x:32053,y:32608,varname:node_2561,prsc:2;n:type:ShaderForge.SFN_Add,id:1744,x:32426,y:33001,varname:node_1744,prsc:2|A-8947-OUT,B-6548-OUT;n:type:ShaderForge.SFN_Set,id:9155,x:33575,y:33758,varname:Updown,prsc:2|IN-6642-OUT;n:type:ShaderForge.SFN_Fresnel,id:6665,x:32402,y:33371,varname:node_6665,prsc:2|EXP-1304-OUT;n:type:ShaderForge.SFN_Slider,id:1304,x:32085,y:33410,ptovrint:False,ptlb:EmissionPower,ptin:_EmissionPower,varname:node_1304,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:2.411938,max:3;n:type:ShaderForge.SFN_Lerp,id:9006,x:33062,y:33012,varname:node_9006,prsc:2|A-4416-OUT,B-4770-RGB,T-1231-OUT;n:type:ShaderForge.SFN_Color,id:4770,x:32763,y:33178,ptovrint:False,ptlb:Outliner,ptin:_Outliner,varname:node_4770,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.8,c2:0.8,c3:1,c4:1;n:type:ShaderForge.SFN_Multiply,id:8461,x:32384,y:33178,varname:node_8461,prsc:2|A-2823-OUT,B-6901-OUT;n:type:ShaderForge.SFN_Multiply,id:6901,x:32183,y:33199,varname:node_6901,prsc:2|A-6054-OUT,B-1739-OUT;n:type:ShaderForge.SFN_Slider,id:1739,x:31830,y:33260,ptovrint:False,ptlb:RefractPower,ptin:_RefractPower,varname:node_1739,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:3.042952,max:5;n:type:ShaderForge.SFN_Set,id:1775,x:32562,y:33407,varname:Emission,prsc:2|IN-6665-OUT;n:type:ShaderForge.SFN_Get,id:6054,x:31966,y:33166,varname:node_6054,prsc:2|IN-1775-OUT;n:type:ShaderForge.SFN_Relay,id:2823,x:32046,y:33105,varname:node_2823,prsc:2|IN-6226-UVOUT;n:type:ShaderForge.SFN_Set,id:6692,x:32643,y:32765,varname:TimerHue,prsc:2|IN-4363-OUT;n:type:ShaderForge.SFN_Get,id:8947,x:32225,y:32916,varname:node_8947,prsc:2|IN-6692-OUT;n:type:ShaderForge.SFN_Get,id:1231,x:32968,y:33172,varname:node_1231,prsc:2|IN-1775-OUT;n:type:ShaderForge.SFN_Set,id:3250,x:32566,y:33178,varname:Refraction,prsc:2|IN-8461-OUT;n:type:ShaderForge.SFN_Get,id:971,x:33041,y:33233,varname:node_971,prsc:2|IN-3250-OUT;n:type:ShaderForge.SFN_Get,id:5198,x:33041,y:33290,varname:node_5198,prsc:2|IN-9308-OUT;n:type:ShaderForge.SFN_RemapRange,id:3287,x:32848,y:32684,varname:node_3287,prsc:2,frmn:-1,frmx:1,tomn:-0.2,tomx:0.2|IN-5894-OUT;n:type:ShaderForge.SFN_Multiply,id:6249,x:32241,y:32544,varname:node_6249,prsc:2|A-7636-OUT,B-239-T,C-2561-OUT;n:type:ShaderForge.SFN_Sin,id:672,x:32476,y:32544,varname:node_672,prsc:2|IN-6249-OUT;n:type:ShaderForge.SFN_Vector1,id:7636,x:32037,y:32532,varname:node_7636,prsc:2,v1:0.5;n:type:ShaderForge.SFN_Relay,id:5894,x:32654,y:32684,varname:node_5894,prsc:2|IN-672-OUT;proporder:195-1304-4770-1739;pass:END;sub:END;*/

Shader "Shader Forge/Rainbow" {
    Properties {
        _Scale ("Scale", Range(0, 1)) = 0.3560196
        _EmissionPower ("EmissionPower", Range(0, 3)) = 2.411938
        _Outliner ("Outliner", Color) = (0.8,0.8,1,1)
        _RefractPower ("RefractPower", Range(0, 5)) = 3.042952
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        GrabPass{ }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform sampler2D _GrabTexture;
            uniform float _Scale;
            uniform float _EmissionPower;
            uniform float4 _Outliner;
            uniform float _RefractPower;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float4 projPos : TEXCOORD3;
                UNITY_FOG_COORDS(4)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                float4 node_239 = _Time;
                float node_2561 = 3.141592654;
                float3 VertexScale = (_Scale*v.normal*(sin((0.5*node_239.g*node_2561))*0.2+0.0));
                float3 node_5198 = VertexScale;
                v.vertex.xyz += node_5198;
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                o.projPos = ComputeScreenPos (o.pos);
                COMPUTE_EYEDEPTH(o.projPos.z);
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                float Emission = pow(1.0-max(0,dot(normalDirection, viewDirection)),_EmissionPower);
                float2 Refraction = (i.uv0*(Emission*_RefractPower));
                float2 sceneUVs = (i.projPos.xy / i.projPos.w) + Refraction;
                float4 sceneColor = tex2D(_GrabTexture, sceneUVs);
////// Lighting:
////// Emissive:
                float node_2561 = 3.141592654;
                float4 node_239 = _Time;
                float node_3654 = (node_239.g/4.0);
                float node_1156 = (node_2561*node_3654);
                float node_4363 = sin(node_1156);
                float TimerHue = node_4363;
                float node_6548 = i.uv0.r;
                float node_1231 = Emission;
                float3 emissive = lerp(saturate(3.0*abs(1.0-2.0*frac(distance(0.5,(TimerHue+node_6548))+float3(0.0,-1.0/3.0,1.0/3.0)))-1),_Outliner.rgb,node_1231);
                float3 finalColor = emissive;
                fixed4 finalRGBA = fixed4(lerp(sceneColor.rgb, finalColor,node_1231),1);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
        Pass {
            Name "ShadowCaster"
            Tags {
                "LightMode"="ShadowCaster"
            }
            Offset 1, 1
            Cull Back
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_SHADOWCASTER
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform float _Scale;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
                float3 normalDir : TEXCOORD1;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                float4 node_239 = _Time;
                float node_2561 = 3.141592654;
                float3 VertexScale = (_Scale*v.normal*(sin((0.5*node_239.g*node_2561))*0.2+0.0));
                float3 node_5198 = VertexScale;
                v.vertex.xyz += node_5198;
                o.pos = UnityObjectToClipPos( v.vertex );
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3 normalDirection = i.normalDir;
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}