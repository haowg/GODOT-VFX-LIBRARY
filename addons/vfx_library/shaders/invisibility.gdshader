shader_type canvas_item;

// 隐形效果
uniform float invisibility_amount : hint_range(0.0, 1.0) = 0.0;
uniform float distortion_amount : hint_range(0.0, 0.05) = 0.02;
uniform sampler2D distortion_texture : hint_default_white;

void fragment() {
    // 轻微扭曲
    vec2 distortion = texture(distortion_texture, UV + vec2(TIME * 0.1, 0.0)).rg;
    distortion = (distortion - 0.5) * distortion_amount * invisibility_amount;
    
    vec4 texture_color = texture(TEXTURE, UV + distortion);
    
    // 边缘微光
    float edge = 1.0 - smoothstep(0.0, 0.2, abs(0.5 - UV.x)) * smoothstep(0.0, 0.2, abs(0.5 - UV.y));
    vec4 edge_glow = vec4(0.5, 0.8, 1.0, 1.0) * edge * invisibility_amount * 0.3;
    
    COLOR = mix(texture_color, vec4(0.0), invisibility_amount * 0.7) + edge_glow;
    COLOR.a = texture_color.a * (1.0 - invisibility_amount * 0.8);
}
