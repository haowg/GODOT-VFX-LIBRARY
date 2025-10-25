shader_type canvas_item;
render_mode unshaded;

uniform float level : hint_range(0.0, 1.0) = 0.0;
uniform vec4 water_albedo : source_color;
uniform float water_opacity : hint_range(0.0, 1.0) = 0.35;
uniform float water_speed = 0.05;
uniform float wave_distortion = 0.2;
uniform int wave_multiplyer = 7;
uniform bool water_texture_on = true;
uniform float reflection_X_offset = 0.0;
uniform float reflection_Y_offset = 0.0;
uniform sampler2D noise_texture: repeat_enable;
uniform sampler2D noise_texture2: repeat_enable;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture;

uniform float pixel_resolution_x : hint_range(1.0, 1280.0) = 64.0;
uniform float pixel_resolution_y : hint_range(1.0, 1280.0) = 64.0;
uniform float edge_fade_width : hint_range(0.0, 0.5) = 0.05;

void fragment() {
    vec2 uv = UV;
    COLOR = vec4(0.0);

    // Lower the resolution for pixel art style
    vec2 pixel_resolution = vec2(pixel_resolution_x, pixel_resolution_y);
    uv *= pixel_resolution;
    uv = floor(uv);
    uv /= pixel_resolution;

    // wave effect at the edge
    float wave = texture(noise_texture, vec2(uv.x * 5.0, TIME * water_speed)).x * 0.02;

    if (uv.y >= level + wave) {
        COLOR.a = 1.0;

        // distorted reflections
        vec2 water_uv = vec2(uv.x, uv.y * float(wave_multiplyer));
        float noise = texture(noise_texture, vec2(water_uv.x + TIME * water_speed, water_uv.y)).x * wave_distortion;
        noise -= (0.5 * wave_distortion);

        // water texture
        if (water_texture_on) {
            float water_texture_limit = 0.35;
            vec4 water_texture = texture(noise_texture2, uv * vec2(0.5, 4.0) + vec2(noise, 0.0));
            float water_texture_value = (water_texture.x < water_texture_limit) ? 1.0 : 0.0;
            COLOR.xyz = vec3(water_texture_value);
        }

        // putting everything together
        vec4 current_texture = texture(SCREEN_TEXTURE, vec2(SCREEN_UV.x + noise + reflection_X_offset, 1.7 - (SCREEN_UV.y - level) + reflection_Y_offset));
        COLOR = mix(COLOR, current_texture, 0.5);
        COLOR = mix(COLOR, water_albedo, water_opacity);

        if (abs(uv.y - (level + wave)) < 0.02) {
            float splash = texture(noise_texture, vec2(uv.x * 5.0, TIME * water_speed)).x * 2.0;
            COLOR.a *= splash;
            float white_factor = 1.0 - smoothstep(level, level + 0.02, uv.y); // Decrease white color towards the lower edge
            COLOR.rgb = mix(COLOR.rgb, vec3(1.0), white_factor); // Add a bit of white color
        }

        float edge_opacity = 1.0;

        // 左侧边缘渐变
        edge_opacity *= smoothstep(0.0, edge_fade_width, UV.x);
        // 右侧边缘渐变
        edge_opacity *= smoothstep(0.0, edge_fade_width, 1.0 - UV.x);

        // 应用边缘透明度
        COLOR.a *= edge_opacity;
    }
}
