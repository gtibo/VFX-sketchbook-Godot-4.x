shader_type spatial;
render_mode unshaded, cull_disabled;

uniform sampler2D alpha_curve_sampler : filter_linear_mipmap, repeat_enable;
uniform sampler2D noise_sampler : filter_linear_mipmap, repeat_enable;

uniform float alpha : hint_range(0.0, 1.0, 0.1) = 1.0;
uniform float dissolve : hint_range(0.0, 1.0, 0.1) = 0.5;
uniform float dissolve_smoothness = 0.0;
uniform float offset = 0.0;

// https://gist.github.com/companje/29408948f1e8be54dd5733a74ca49bb9
float map(float value, float min1, float max1, float min2, float max2) {
	return min2 + (value - min1) * (max2 - min2) / (max1 - min1);
}

float fresnel(float amount, vec3 normal, vec3 view)
{
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0 )), amount);
}

void fragment() {
	float noise_a = texture(noise_sampler, UV + vec2(offset * 0.84, 0.0)).x;
	float noise_b = texture(noise_sampler, UV + vec2(0.0, offset * 0.24)).x;
	
	float noise = noise_a * noise_b;
	
	float map_dissolve_progress = map(dissolve, 0.0, 1.0, - dissolve_smoothness, 1.0 + dissolve_smoothness);
	float alpha_mask = clamp(smoothstep(map_dissolve_progress - dissolve_smoothness, map_dissolve_progress + dissolve_smoothness, (noise) - texture(alpha_curve_sampler, vec2(UV.y, 0.0)).x), 0.0, 1.0);
	
	ALPHA = alpha_mask * alpha * (1.0 - fresnel(0.25, NORMAL, VIEW));
}
