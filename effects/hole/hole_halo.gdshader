shader_type spatial;
render_mode cull_disabled;

uniform sampler2D halo_sampler : filter_linear_mipmap, repeat_enable;
uniform vec3 color : source_color;
uniform float intensity = 1.0;
uniform float alpha : hint_range(0.0, 1.0, 0.1) = 1.0;

float fresnel(float amount, vec3 normal, vec3 view)
{
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0 )), amount);
}


void fragment() {
	float a = texture(halo_sampler, vec2(UV.x + TIME * 0.05, 0.0)).x;
	float b = texture(halo_sampler, vec2(UV.x + TIME * 0.02, 0.0)).x;
	float m = smoothstep(0.2, 0.8, a * b);
	ALBEDO = color;
	EMISSION = color * intensity;
	ALPHA = m * sin(UV.y * PI * 2.0) * (1.0 - fresnel(0.4, NORMAL, VIEW)) * 0.4 * (UV.y + ((sin(UV.x * PI * 8.0 + TIME * 0.25) + 1.0) * 0.04)) * alpha;
}
