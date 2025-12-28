shader_type canvas_item;

group_uniforms DynamicParams;
uniform float scanning_progress = 0.0;
uniform float visibility : hint_range(0.0, 1.0, 0.01) = 1.0;

group_uniforms FixedParams;
uniform vec4 color: source_color;
uniform float initial_outline_pixel_size = 32.0;
uniform float final_outline_pixel_size = 2.0;
uniform float initial_fill_transparency = 2.0;
uniform float final_fill_transparency = 0.15;
uniform float initial_pixelize_power = 9.0;
uniform float final_pixelize_power = 1.0;

float get_scanner_alpha(sampler2D tex, vec2 pixel_size, vec2 uv) {
	vec4 pixel = texture(tex, uv);
	if (pixel.a < 0.5) {
		vec2 outline_size = pixel_size * mix(
			initial_outline_pixel_size, final_outline_pixel_size, scanning_progress
		);
		for (float x = -outline_size.x; x <= outline_size.x; x += pixel_size.x) {
			for (float y = -outline_size.y; y <= outline_size.y; y += pixel_size.y) {
				vec4 surrounding_pixel = texture(tex, uv + vec2(x, y));
				// If one of the surrounding pixels is visible: draw an outline (opaque color)
				if (surrounding_pixel.a > 0.5) {
					return 1.0;
				}
			}
		}
		return 0.0;
	}
	float fill_transparency = mix(
		initial_fill_transparency, final_fill_transparency, scanning_progress
	);
	return fill_transparency;
}

void fragment() {
	// Scale the UV (using powers of 2) to obtain the effect of pixelization
	vec2 pixelized_texture_size = vec2(textureSize(TEXTURE, 0)) / pow(
		2.0, floor(mix(initial_pixelize_power, final_pixelize_power, scanning_progress))
	);
	vec2 pixelized_uv = (
		floor(UV * pixelized_texture_size) + ceil(UV * pixelized_texture_size)
	) * 0.5 / pixelized_texture_size;
	COLOR = color;
	COLOR.a *= visibility * scanning_progress * get_scanner_alpha(
		TEXTURE, TEXTURE_PIXEL_SIZE, pixelized_uv
	);
}