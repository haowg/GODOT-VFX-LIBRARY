// Recolor - 颜色替换/染色
shader_type canvas_item;

// 目标颜色
uniform vec4 target_color : source_color = vec4(1.0, 0.3, 0.3, 1.0);
// 混合强度 (0.0 = 原色, 1.0 = 完全变色)
uniform float mix_amount : hint_range(0.0, 1.0) = 0.7;
// 保持亮度
uniform bool preserve_luminance = true;

void fragment() {
	vec4 original_color = texture(TEXTURE, UV);
	
	// 计算原始颜色的亮度
	float luminance = dot(original_color.rgb, vec3(0.299, 0.587, 0.114));
	
	// 混合原色和目标色
	vec3 new_color = mix(original_color.rgb, target_color.rgb, mix_amount);
	
	// 可选：保持原始亮度
	if (preserve_luminance) {
		float new_luminance = dot(new_color, vec3(0.299, 0.587, 0.114));
		if (new_luminance > 0.0) {
			new_color *= luminance / new_luminance;
		}
	}
	
	COLOR = vec4(new_color, original_color.a);
}