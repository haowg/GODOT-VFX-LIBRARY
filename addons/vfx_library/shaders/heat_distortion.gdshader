shader_type canvas_item;

// 热浪扭曲效果
uniform float distortion_speed : hint_range(0.0, 5.0) = 2.0;
uniform float distortion_amount : hint_range(0.0, 0.1) = 0.03;
uniform sampler2D noise_texture : hint_default_white;

void fragment() {
    // 使用噪声纹理创建扭曲
    vec2 noise_uv = UV + vec2(TIME * distortion_speed * 0.1, TIME * distortion_speed * 0.2);
    vec2 distortion = texture(noise_texture, noise_uv).rg;
    distortion = (distortion - 0.5) * distortion_amount;
    
    vec4 texture_color = texture(TEXTURE, UV + distortion);
    COLOR = texture_color;
}
