shader_type canvas_item;

// 发光边缘效果 (Outline/Glow)
uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 0.5, 1.0);
uniform float outline_width : hint_range(0.0, 10.0) = 2.0;
uniform float glow_intensity : hint_range(0.0, 2.0) = 1.0;

void fragment() {
    vec4 texture_color = texture(TEXTURE, UV);
    
    // 采样周围像素检测边缘
    float alpha_sum = 0.0;
    float samples = 8.0;
    float step_size = outline_width / 100.0;
    
    for (float angle = 0.0; angle < 6.28318; angle += 6.28318 / samples) {
        vec2 offset = vec2(cos(angle), sin(angle)) * step_size;
        alpha_sum += texture(TEXTURE, UV + offset).a;
    }
    
    // 如果当前像素透明但周围有不透明像素，就是边缘
    float outline = step(0.1, alpha_sum) * (1.0 - texture_color.a);
    
    COLOR = mix(texture_color, outline_color * glow_intensity, outline);
    COLOR.a = max(texture_color.a, outline);
}
