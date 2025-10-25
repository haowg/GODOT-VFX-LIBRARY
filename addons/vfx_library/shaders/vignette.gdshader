shader_type canvas_item;

// 屏幕红边效果 (Vignette)
uniform float vignette_strength : hint_range(0.0, 1.0) = 0.5;
uniform float vignette_size : hint_range(0.0, 2.0) = 0.8;
uniform vec4 vignette_color : source_color = vec4(1.0, 0.0, 0.0, 1.0);

void fragment() {
    vec4 texture_color = texture(TEXTURE, UV);
    
    // 计算到中心的距离
    vec2 center = vec2(0.5, 0.5);
    float dist = distance(UV, center);
    
    // 创建渐晕效果
    float vignette = smoothstep(vignette_size, vignette_size - 0.5, dist);
    vignette = 1.0 - vignette;
    
    COLOR = mix(texture_color, texture_color * vignette_color, vignette * vignette_strength);
}
