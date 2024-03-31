shader_type spatial;
render_mode cull_disabled;

uniform sampler2D voronoi_sampler : filter_linear_mipmap, repeat_enable;
uniform sampler2D gradient_sampler : filter_linear, source_color;

uniform float def_x = 0.0;
uniform float def_z = 0.0;

#include "res://shared/shaders/fresnel.gdshaderinc"
#include "res://shared/shaders/rotate_x.gdshaderinc"
#include "res://shared/shaders/rotate_z.gdshaderinc"

void vertex() {
	VERTEX += sin((UV.y - TIME * 4.0) * PI * 3.0) * NORMAL * (1.0 - UV.y) * 0.1;
	float r_x = def_x * UV.y;
	float r_z = def_z * UV.y;
	VERTEX *= rotateX(r_x) * rotateZ(r_z);
}

void fragment() {
	float voronoi = texture(voronoi_sampler, (UV - vec2(0.0, TIME * 3.0)) * vec2(1.0, 0.8) * 0.6).x;
	vec3 gradient = texture(gradient_sampler, vec2(UV.y, 0.0) * (voronoi * 0.4 + 0.6)).rgb;
	ALBEDO = gradient;
	EMISSION = gradient * 1.45 + step(0.25, fresnel(2.0, NORMAL, VIEW)) * gradient * 2.0;
	ALPHA *= step(-0.15, voronoi - UV.y);
	ALPHA_SCISSOR_THRESHOLD = 0.5;
}
