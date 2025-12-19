shader_type spatial;

render_mode unshaded, depth_prepass_alpha;

uniform vec3 base_color : source_color = vec3(0.0, 1.0, 0.0); // Mặc định là xanh lá
uniform float scanline_speed : hint_range(-10.0, 10.0) = 4.0;
uniform float scanline_density : hint_range(1.0, 500.0) = 150.0;
uniform float fresnel_power : hint_range(0.1, 10.0) = 5.0;
uniform float alpha_intensity : hint_range(0.0, 1.0) = 0.9;

void fragment() {
    ALBEDO = base_color;
    // Vertical Line
    float mask1 = sin((UV.y - TIME) * scanline_speed) * 0.2 + 0.6;
    // Horizontal line
    float mask2 = sin((SCREEN_UV.x - TIME) * 30.0) * 0.2 + 0.8;
    
    // Scanlines Factor
    float scanlines_factor = pow((sin((SCREEN_UV.y - TIME / 15.0) * scanline_density) * 0.5 + 0.5), 2.5) * mask1 * mask2;

    // Fresnel
    float fresnel_factor = pow((1.0 - dot(VIEW, NORMAL)), fresnel_power);

    ALPHA = pow(scanlines_factor + fresnel_factor, alpha_intensity);
}