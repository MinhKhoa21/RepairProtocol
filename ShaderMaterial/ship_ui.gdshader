shader_type spatial;

render_mode unshaded, depth_prepass_alpha;

uniform vec3 base_color : source_color = vec3(0.0, 1.0, 0.0);
// Dùng vec3 cho scan_color nếu không cần alpha riêng, hoặc vec4 như bạn cũng được
uniform vec4 scan_color : source_color = vec4(1.0, 0.2, 0.0, 0.8); 
uniform float scanline_speed : hint_range(-10.0, 10.0) = 4.0;
uniform float scanline_density : hint_range(1.0, 500.0) = 150.0;
uniform float fresnel_power : hint_range(0.1, 10.0) = 5.0;
uniform float alpha_intensity : hint_range(0.0, 1.0) = 0.9;

// Biến này để Script bật tắt
uniform bool is_scanned = false; 

void fragment() {
    // --- SỬA ĐOẠN NÀY ---
    // Chọn màu dựa trên biến is_scanned
    vec3 target_albedo = base_color;
    if (is_scanned) {
        target_albedo = scan_color.rgb;
    }
    
    ALBEDO = target_albedo;
    // --------------------

    // Vertical Line
    float mask1 = sin((UV.y - TIME) * scanline_speed) * 0.2 + 0.6;
    // Horizontal line
    float mask2 = sin((SCREEN_UV.x - TIME) * 30.0) * 0.2 + 0.8;
    
    float scanlines_factor = pow((sin((SCREEN_UV.y - TIME / 15.0) * scanline_density) * 0.5 + 0.5), 2.5) * mask1 * mask2;

    float fresnel_factor = pow((1.0 - dot(VIEW, NORMAL)), fresnel_power);

    ALPHA = pow(scanlines_factor + fresnel_factor, alpha_intensity);
}