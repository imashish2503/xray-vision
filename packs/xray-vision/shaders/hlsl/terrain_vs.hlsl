// Legacy HLSL vertex shader (Windows 10 older builds).
// Not supported on modern Bedrock/MCPE (RenderDragon).

cbuffer Matrices : register(b0) {
    float4x4 u_mvp;
};

struct VS_IN {
    float3 pos : POSITION;
    float2 uv  : TEXCOORD0;
};

struct VS_OUT {
    float4 pos : SV_POSITION;
    float2 uv  : TEXCOORD0;
};

VS_OUT VSMain(VS_IN i) {
    VS_OUT o;
    o.pos = mul(u_mvp, float4(i.pos, 1.0));
    o.uv  = i.uv;
    return o;
}