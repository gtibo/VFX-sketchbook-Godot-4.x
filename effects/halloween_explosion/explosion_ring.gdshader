shader_type spatial;

void fragment() {
	ALPHA = sin(UV.y * PI);
	EMISSION = vec3(1.0);
}
