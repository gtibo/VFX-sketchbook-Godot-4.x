shader_type spatial;
render_mode particle_trails, cull_disabled;

varying vec4 custom;

void vertex() {
	custom = INSTANCE_CUSTOM;
}

void fragment() {
	float edge = sin(UV.x * PI) * sin(UV.y * PI);
	ALBEDO = COLOR.rgb;
	EMISSION = COLOR.rgb * 1.6 * COLOR.a;
	ALPHA = step(0.2, edge) * (1.0 - UV.y) * COLOR.a;
}
