shader_type spatial;
render_mode cull_disabled, shadows_disabled;

uniform sampler2D wind_sampler : repeat_enable, filter_linear;
uniform sampler2D albedo_sampler : source_color, repeat_disable, filter_nearest;
uniform float intensity = 0.25;
uniform float waviness = 1.0;
uniform float wind_speed = 0.025;

#include "res://shared/shaders/rotate_x.gdshaderinc"
#include "res://shared/shaders/rotate_y.gdshaderinc"
#include "res://shared/shaders/rotate_z.gdshaderinc"

void vertex() {
	vec2 offset = NODE_POSITION_WORLD.xz * 0.05;
	float t = TIME * wind_speed;
	float n_x = (texture(wind_sampler, offset + vec2(t, 0.0)).x - 0.5) * (1.0 - UV.y * waviness) * intensity;
	float n_y = (texture(wind_sampler, offset + vec2(0.0, t)).x - 0.5) * (1.0 - UV.y * waviness) * intensity;
	VERTEX *= rotateX(n_x) * rotateY(COLOR.x * TAU) * rotateZ(n_y);
	NORMAL = vec3(0.0, 1.0, 0.0);
}

void fragment() {
	ALBEDO = texture(albedo_sampler, vec2(UV.x + COLOR.x * 0.49, 0.0)).rgb;
	NORMAL = NORMAL * (float(FRONT_FACING) * 2.0 - 1.0);
	ROUGHNESS = 1.0;
	ALBEDO = mix(ALBEDO, ALBEDO * vec3(0.15), UV.y);
	SPECULAR = 0.0;
}