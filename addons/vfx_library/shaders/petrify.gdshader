shader_type canvas_item;

// 石化效果
uniform float petrify_amount : hint_range(0.0, 1.0) = 0.0;
uniform vec4 stone_color : source_color = vec4(0.5, 0.5, 0.5, 1.0);
uniform sampler2D crack_texture : hint_default_white;
uniform float crack_intensity : hint_range(0.0, 1.0) = 0.5;

void fragment() {
    vec4 texture_color = texture(TEXTURE, UV);
    vec4 cracks = texture(crack_texture, UV);
    
    // 去饱和度变成灰色
    float gray = dot(texture_color.rgb, vec3(0.299, 0.587, 0.114));
    vec3 stone = mix(vec3(gray), stone_color.rgb, 0.5);
    
    // 混合石化颜色
    vec3 petrified = mix(texture_color.rgb, stone, petrify_amount);
    
    // 添加裂纹
    petrified = mix(petrified, petrified * 0.5, cracks.r * crack_intensity * petrify_amount);
    
    COLOR = vec4(petrified, texture_color.a);
}
