shader_type canvas_item;

// 冰冻效果
uniform float freeze_amount : hint_range(0.0, 1.0) = 0.0;
uniform vec4 ice_color : source_color = vec4(0.5, 0.8, 1.0, 1.0);
uniform sampler2D ice_texture : hint_default_white;
uniform float crystal_intensity : hint_range(0.0, 1.0) = 0.5;

void fragment() {
    vec4 texture_color = texture(TEXTURE, UV);
    vec4 ice_pattern = texture(ice_texture, UV + vec2(TIME * 0.02, 0.0));
    
    // 混合冰冻颜色
    vec3 frozen_color = mix(texture_color.rgb, ice_color.rgb, freeze_amount * 0.6);
    
    // 添加结晶效果
    frozen_color += ice_pattern.rgb * crystal_intensity * freeze_amount;
    
    COLOR = vec4(frozen_color, texture_color.a);
}
