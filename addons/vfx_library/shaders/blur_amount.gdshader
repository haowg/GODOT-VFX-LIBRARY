shader_type canvas_item;

uniform float blur_amount : hint_range(0.0, 0.2);

void fragment() {
    vec2 resolution = vec2(textureSize(TEXTURE, 0));
    vec4 sum = vec4(0.0);
    vec2 blur = blur_amount * resolution;

    for(int i = -4; i <= 4; i++) {
        for(int j = -4; j <= 4; j++) {
            vec2 shift = vec2(float(i), float(j)) / resolution;
            sum += texture(TEXTURE, UV + shift * blur);
        }
    }

    COLOR = sum / 81.0;
}