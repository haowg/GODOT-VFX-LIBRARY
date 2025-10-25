shader_type canvas_item;

// 灰度效果 (慢动作时使用)
uniform float grayscale_amount : hint_range(0.0, 1.0) = 0.0;
uniform vec3 luminance_weights = vec3(0.299, 0.587, 0.114);

void fragment() {
    vec4 texture_color = texture(TEXTURE, UV);
    
    // 计算亮度
    float luminance = dot(texture_color.rgb, luminance_weights);
    vec3 grayscale = vec3(luminance);
    
    COLOR = vec4(mix(texture_color.rgb, grayscale, grayscale_amount), texture_color.a);
}
