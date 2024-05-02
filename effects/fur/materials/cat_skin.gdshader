shader_type spatial;

uniform sampler2D albedo_sampler : source_color, filter_linear_mipmap, repeat_disable;

void fragment() {
	ALBEDO = texture(albedo_sampler, UV).rgb;
	ROUGHNESS = 0.98;
	SPECULAR = 0.25;
}
