shader_type canvas_item;

// 燃烧效果
uniform float burn_amount : hint_range(0.0, 1.0) = 0.0;
uniform vec4 fire_color1 : source_color = vec4(1.0, 0.8, 0.2, 1.0);
uniform vec4 fire_color2 : source_color = vec4(1.0, 0.3, 0.0, 1.0);
uniform sampler2D distortion_texture : hint_default_white;
uniform float distortion_strength : hint_range(0.0, 0.1) = 0.03;

void fragment() {
    // 热浪扭曲
    vec2 distortion = texture(distortion_texture, UV + vec2(TIME * 0.1, TIME * 0.2)).rg;
    distortion = (distortion - 0.5) * distortion_strength * burn_amount;
    
    vec4 texture_color = texture(TEXTURE, UV + distortion);
    
    // 火焰颜色动画
    float fire_gradient = sin(UV.y * 10.0 - TIME * 5.0) * 0.5 + 0.5;
    vec4 fire_color = mix(fire_color1, fire_color2, fire_gradient);
    
    // 边缘燃烧
    float burn_edge = smoothstep(0.3, 0.7, UV.y + burn_amount * 1.5 - 0.5);
    
    COLOR = mix(texture_color, fire_color, burn_edge * burn_amount * 0.6);
    COLOR.a = texture_color.a;
}
