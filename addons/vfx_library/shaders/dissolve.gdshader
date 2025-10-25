shader_type canvas_item;

// 溶解消失效果
uniform float dissolve_amount : hint_range(0.0, 1.0) = 0.0;
uniform sampler2D dissolve_texture : hint_default_white;
uniform vec4 edge_color : source_color = vec4(1.0, 0.5, 0.0, 1.0);
uniform float edge_width : hint_range(0.0, 0.2) = 0.05;

void fragment() {
    vec4 texture_color = texture(TEXTURE, UV);
    float noise = texture(dissolve_texture, UV).r;
    
    // 计算溶解
    float dissolve_edge = dissolve_amount + edge_width;
    float alpha = smoothstep(dissolve_amount, dissolve_edge, noise);
    
    // 边缘发光
    float edge = smoothstep(dissolve_amount, dissolve_amount + edge_width, noise);
    edge = edge * (1.0 - smoothstep(dissolve_amount + edge_width * 0.5, dissolve_edge, noise));
    
    COLOR = mix(texture_color, edge_color, edge);
    COLOR.a = texture_color.a * alpha;
}
