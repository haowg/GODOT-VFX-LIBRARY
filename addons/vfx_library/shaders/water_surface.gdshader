shader_type canvas_item;

// 水面波纹效果
uniform vec2 wave_direction = vec2(1.0, 0.0);
uniform float wave_speed : hint_range(0.0, 5.0) = 1.0;
uniform float wave_frequency : hint_range(0.0, 20.0) = 5.0;
uniform float wave_amplitude : hint_range(0.0, 0.1) = 0.02;
uniform vec4 water_tint : source_color = vec4(0.5, 0.7, 1.0, 0.8);

void fragment() {
    // 波纹扭曲
    vec2 wave_offset = vec2(
        sin(UV.y * wave_frequency + TIME * wave_speed) * wave_amplitude,
        cos(UV.x * wave_frequency + TIME * wave_speed) * wave_amplitude
    );
    
    vec4 texture_color = texture(TEXTURE, UV + wave_offset);
    COLOR = texture_color * water_tint;
}
