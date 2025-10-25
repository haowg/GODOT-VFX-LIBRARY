shader_type canvas_item;

// 受击闪白效果
uniform float flash_amount : hint_range(0.0, 1.0) = 0.0;
uniform vec4 flash_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
    vec4 texture_color = texture(TEXTURE, UV);
    COLOR = mix(texture_color, flash_color, flash_amount * texture_color.a);
    COLOR.a = texture_color.a;
}
