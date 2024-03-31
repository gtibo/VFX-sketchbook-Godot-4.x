shader_type spatial;

uniform vec3 albedo : source_color;
uniform vec3 emission : source_color;

#include "res://shared/shaders/fresnel.gdshaderinc"

void fragment() {
	float f = fresnel(1.0, NORMAL, VIEW);
	float light_mask = step(0.4, f);
	ALBEDO = mix(albedo, emission, light_mask);
	EMISSION = ALBEDO * 2.0 * f;
}