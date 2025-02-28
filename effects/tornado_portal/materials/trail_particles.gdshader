shader_type spatial;
render_mode unshaded, particle_trails;

uniform vec3 color : source_color;
uniform float intensity = 1.0;

void fragment() {
	ALBEDO = color * intensity;
	ALPHA = COLOR.a * (1.0 - UV.y);
}
