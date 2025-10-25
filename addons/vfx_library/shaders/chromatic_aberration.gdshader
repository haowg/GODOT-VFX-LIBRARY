shader_type canvas_item;

// 色差效果 (RGB分离)
uniform float aberration_amount : hint_range(0.0, 0.1) = 0.01;
uniform vec2 aberration_direction = vec2(1.0, 0.0);

void fragment() {
    vec2 offset = aberration_direction * aberration_amount;
    
    float r = texture(TEXTURE, UV + offset).r;
    float g = texture(TEXTURE, UV).g;
    float b = texture(TEXTURE, UV - offset).b;
    float a = texture(TEXTURE, UV).a;
    
    COLOR = vec4(r, g, b, a);
}
