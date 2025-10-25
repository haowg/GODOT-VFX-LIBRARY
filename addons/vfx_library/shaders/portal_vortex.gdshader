shader_type canvas_item;

// 传送门漩涡效果
uniform float vortex_speed : hint_range(0.0, 5.0) = 2.0;
uniform float vortex_strength : hint_range(0.0, 1.0) = 0.5;
uniform vec4 portal_color1 : source_color = vec4(0.5, 0.2, 1.0, 1.0);
uniform vec4 portal_color2 : source_color = vec4(0.2, 0.8, 1.0, 1.0);

void fragment() {
    vec2 center = vec2(0.5, 0.5);
    vec2 uv_centered = UV - center;
    
    // 计算到中心的距离和角度
    float dist = length(uv_centered);
    float angle = atan(uv_centered.y, uv_centered.x);
    
    // 旋转漩涡
    float spiral = angle + dist * 10.0 - TIME * vortex_speed;
    
    // 创建旋转的 UV
    vec2 vortex_uv = vec2(
        cos(spiral) * dist + 0.5,
        sin(spiral) * dist + 0.5
    );
    
    // 混合两个颜色
    float color_mix = sin(dist * 10.0 - TIME * vortex_speed * 2.0) * 0.5 + 0.5;
    vec4 portal_color = mix(portal_color1, portal_color2, color_mix);
    
    vec4 texture_color = texture(TEXTURE, mix(UV, vortex_uv, vortex_strength));
    COLOR = mix(texture_color, portal_color, 0.6 * (1.0 - dist * 2.0));
}
