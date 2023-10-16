shader_type spatial;
render_mode cull_disabled;

uniform sampler2D noise_sampler : filter_linear_mipmap, repeat_enable;
uniform float alpha : hint_range(0.0, 1.0, 0.1) = 1.0;
uniform sampler2D gradient_sampler : source_color;
uniform float intensity = 1.0;
uniform float offset = 0.0;
uniform float dissolve : hint_range(0.0, 1.0, 0.1) = 0.5;
uniform float dissolve_smoothness = 0.0;

// https://gist.github.com/companje/29408948f1e8be54dd5733a74ca49bb9
float map(float value, float min1, float max1, float min2, float max2) {
	return min2 + (value - min1) * (max2 - min2) / (max1 - min1);
}

void vertex() {
	VERTEX.y += sin(UV.x * PI * 4.0 + NODE_POSITION_WORLD.y + TIME) * 0.1;
}

void fragment() {
	float noise = texture(noise_sampler, UV * vec2(2.0, 0.6) + vec2(0.0, offset)).x;
	float map_dissolve_progress = map(dissolve, 0.0, 1.0, - dissolve_smoothness, 1.0 + dissolve_smoothness);
	vec3 gradient = texture(gradient_sampler, vec2(noise * (1.0 - dissolve), 0.0)).rgb;
	ALBEDO = gradient;
	EMISSION = gradient * intensity;
	float alpha_mask = clamp(smoothstep(map_dissolve_progress - dissolve_smoothness, map_dissolve_progress + dissolve_smoothness, (noise) - (1.0 - sin(UV.y * PI))), 0.0, 1.0);
	
	ALPHA = alpha * COLOR.a * alpha_mask;
}
