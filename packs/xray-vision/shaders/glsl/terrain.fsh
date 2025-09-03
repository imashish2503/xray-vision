// Legacy GLSL fragment shader (OpenGL ES 2.0 style).
// Not supported on modern Bedrock/MCPE (RenderDragon).
// This boosts saturation/brightness to help highlight colorful textures.

precision mediump float;

varying vec2 v_uv;
uniform sampler2D u_texture;

vec3 rgb2hsv(vec3 c) {
    vec4 K = vec4(0., -1./3., 2./3., -1.);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    float h = abs(q.z + (q.w - q.y) / (6. * d + e));
    float s = d / (q.x + e);
    float v = q.x;
    return vec3(h, s, v);
}

vec3 hsv2rgb(vec3 c) {
    vec3 p = abs(fract(c.xxx + vec3(0., 2./3., 1./3.)) * 6. - 3.);
    vec3 a = clamp(p - 1., 0., 1.);
    return c.z * mix(vec3(1.), a, c.y);
}

void main() {
    vec4 tex = texture2D(u_texture, v_uv);

    // Boost saturation of already colorful pixels, dim low-sat ones
    vec3 hsv = rgb2hsv(tex.rgb);
    float boost = smoothstep(0.2, 1.0, hsv.y) * 0.6 + 1.0;
    hsv.y = clamp(hsv.y * boost, 0.0, 1.0);
    hsv.z = clamp(hsv.z * 1.2, 0.0, 1.0);

    vec3 rgb = hsv2rgb(hsv);

    // Attempt to fade low-saturation (stone-like) colors slightly
    float alpha = mix(0.35, 1.0, smoothstep(0.15, 0.5, hsv.y));

    gl_FragColor = vec4(rgb, alpha);
}