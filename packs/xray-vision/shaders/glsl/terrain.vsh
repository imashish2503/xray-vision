// Legacy example GLSL vertex shader (OpenGL ES 2.0 style).
// Note: Modern Bedrock (RenderDragon) won't load this.

attribute vec3 a_position;
attribute vec2 a_texcoord0;

uniform mat4 u_mvp;

varying vec2 v_uv;

void main() {
    v_uv = a_texcoord0;
    gl_Position = u_mvp * vec4(a_position, 1.0);
}