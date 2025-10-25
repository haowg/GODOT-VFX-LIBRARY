shader_type canvas_item;

uniform float time;
uniform float shake_intensity : hint_range(0.0, 0.2);

void fragment() {
    vec2 uv = UV;
    uv.x += sin(time * 50.0) * shake_intensity;
    uv.y += cos(time * 50.0) * shake_intensity;
    COLOR = texture(TEXTURE, uv);
}