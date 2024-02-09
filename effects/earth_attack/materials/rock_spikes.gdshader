shader_type spatial;

uniform sampler2D albedo_texture : source_color;
uniform sampler2D normal_texture : hint_normal;
uniform vec3 fresnel_color : source_color;
varying vec3 object_normal;

#include "res://shared/shaders/fresnel.gdshaderinc"

void vertex() {
	object_normal = NORMAL;
}

void fragment() {
	vec3 albedo = texture(albedo_texture, UV).rgb;
	ALBEDO = albedo;
	EMISSION = fresnel_color * step(0.5, fresnel(1.0, NORMAL, VIEW)) * 2.0 * clamp(object_normal.y, 0.0, 1.0);
	NORMAL_MAP = texture(normal_texture, UV).xyz;
}