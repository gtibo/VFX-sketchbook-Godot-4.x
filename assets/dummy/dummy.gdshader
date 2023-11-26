shader_type spatial;
render_mode cull_back;

uniform sampler2D albedo_sampler : filter_linear_mipmap, source_color;
uniform sampler2D roughness_sampler : filter_linear_mipmap, hint_roughness_r;
uniform sampler2D normal_sampler : filter_linear_mipmap, hint_normal;

uniform vec3 emission_color : source_color;
uniform float emission_strength = 1.0;
uniform float emission_blend : hint_range(0.0, 1.0, 0.1) = 0.0;

float fresnel(float amount, vec3 normal, vec3 view)
{
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0)), amount);
}

void fragment() {
	vec3 albedo_color = texture(albedo_sampler, UV).rgb;
	ALBEDO = mix(albedo_color, emission_color, emission_blend);
	EMISSION = mix(vec3(0.0), emission_color * emission_strength, emission_blend) + albedo_color * step(0.6, fresnel(1.0, NORMAL, VIEW)) * 0.3;
	NORMAL_MAP = texture(normal_sampler, UV).xyz;
	ROUGHNESS = texture(roughness_sampler, UV).x;
}
