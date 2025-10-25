shader_type canvas_item;

// 径向模糊效果 (用于冲击波)
uniform float blur_strength : hint_range(0.0, 0.1) = 0.03;
uniform vec2 blur_center = vec2(0.5, 0.5);
uniform int samples : hint_range(4, 32) = 16;

void fragment() {
    vec2 direction = UV - blur_center;
    
    vec4 color = vec4(0.0);
    for (int i = 0; i < samples; i++) {
        float t = float(i) / float(samples - 1);
        vec2 offset = direction * blur_strength * t;
        color += texture(TEXTURE, UV - offset);
    }
    
    COLOR = color / float(samples);
}
