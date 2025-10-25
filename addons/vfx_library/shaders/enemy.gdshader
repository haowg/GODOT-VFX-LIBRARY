shader_type canvas_item;

uniform float blur_amount : hint_range(0.0, 0.2);
uniform float shake_intensity : hint_range(0.0, 0.2);
uniform float white_intensity : hint_range(0.0, 1.0);
uniform float time;

void fragment() {
    vec2 resolution = vec2(textureSize(TEXTURE, 0));
    vec4 sum = vec4(0.0);
    vec2 blur = blur_amount * resolution;

    // Shake effect
    vec2 uv = UV;
    uv.x += sin(time * 50.0) * shake_intensity;
    uv.y += cos(time * 50.0) * shake_intensity;

    // Blur effect
    for(int i = -4; i <= 4; i++) {
        for(int j = -4; j <= 4; j++) {
            vec2 shift = vec2(float(i), float(j)) / resolution;
            sum += texture(TEXTURE, uv + shift * blur);
        }
    }

    vec4 final_color = sum / 81.0;
    vec4 white = vec4(1.0, 1.0, 1.0, final_color.a);
    COLOR = mix(final_color, white, white_intensity);
}