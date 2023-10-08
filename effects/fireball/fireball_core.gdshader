shader_type spatial;

void fragment() {
	SPECULAR = 0.0;
	ALBEDO = vec3(0.1);
	EMISSION = vec3(0.0);
	//ALPHA = step(0.5, 1.0 - distance(UV, vec2(0.5)));
}
