shader_type canvas_item;

// 无敌闪烁效果
uniform float blink_speed : hint_range(0.0, 20.0) = 10.0;
uniform float min_alpha : hint_range(0.0, 1.0) = 0.3;

void fragment() {
    vec4 texture_color = texture(TEXTURE, UV);
    float blink = sin(TIME * blink_speed) * 0.5 + 0.5;
    blink = mix(min_alpha, 1.0, blink);
    COLOR = texture_color;
    COLOR.a *= blink;
}
