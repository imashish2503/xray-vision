// Legacy HLSL pixel shader (Windows 10 older builds).
// Not supported on modern Bedrock/MCPE (RenderDragon).

Texture2D u_texture : register(t0);
SamplerState samp   : register(s0);

float3 rgb2hsv(float3 c) {
    float4 K = float4(0., -1./3., 2./3., -1.);
    float4 p = lerp(float4(c.bg, K.wz), float4(c.gb, K.xy), step(c.b, c.g));
    float4 q = lerp(float4(p.xyw, c.r), float4(c.r, p.yzx), step(p.x, c.r));
    float d = q.x - min(q.w, q.y);
    float e = 1e-10;
    float h = abs(q.z + (q.w - q.y) / (6. * d + e));
    float s = d / (q.x + e);
    float v = q.x;
    return float3(h, s, v);
}

float3 hsv2rgb(float3 c) {
    float3 p = abs(frac(c.xxx + float3(0., 2./3., 1./3.)) * 6. - 3.);
    float3 a = saturate(p - 1.);
    return c.z * lerp(float3(1., 1., 1.), a, c.y);
}

struct PS_IN {
    float4 pos : SV_POSITION;
    float2 uv  : TEXCOORD0;
};

float4 PSMain(PS_IN i) : SV_Target {
    float4 tex = u_texture.Sample(samp, i.uv);

    float3 hsv = rgb2hsv(tex.rgb);
    float boost = smoothstep(0.2, 1.0, hsv.y) * 0.6 + 1.0;
    hsv.y = saturate(hsv.y * boost);
    hsv.z = saturate(hsv.z * 1.2);
    float3 rgb = hsv2rgb(hsv);

    float alpha = lerp(0.35, 1.0, smoothstep(0.15, 0.5, hsv.y));
    return float4(rgb, alpha);
}