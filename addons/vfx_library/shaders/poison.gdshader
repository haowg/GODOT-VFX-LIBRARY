shader_type canvas_item;

// 中毒效果
uniform float poison_amount : hint_range(0.0, 1.0) = 0.0;
uniform vec4 poison_color : source_color = vec4(0.3, 1.0, 0.3, 1.0);
uniform float pulse_speed : hint_range(0.0, 10.0) = 3.0;

void fragment() {
    vec4 texture_color = texture(TEXTURE, UV);
    
    // 脉动效果
    float pulse = sin(TIME * pulse_speed) * 0.5 + 0.5;
    float poison_intensity = poison_amount * pulse * 0.5;
    
    // 混合毒性颜色
    vec3 poisoned_color = mix(texture_color.rgb, poison_color.rgb, poison_intensity);
    
    COLOR = vec4(poisoned_color, texture_color.a);
}
