shader_type spatial;

uniform float intensity = 1.0;
uniform vec3 color : source_color;
uniform float lifetime = 1.0;

void vertex() {
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(vec4(normalize(cross(vec3(0.0, 1.0, 0.0), INV_VIEW_MATRIX[2].xyz)), 0.0), vec4(0.0, 1.0, 0.0, 0.0), vec4(normalize(cross(INV_VIEW_MATRIX[0].xyz, vec3(0.0, 1.0, 0.0))), 0.0), MODEL_MATRIX[3]);
	MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
	VERTEX.y -= 0.5;
	VERTEX.y *= 1.0 + sin(lifetime * PI);
	VERTEX.x += sin(UV.y * PI * 3.0 - TIME * 10.0) * 0.02 * UV.y; 
}

void fragment() {
	float ease = (1.0 - UV.y);
	ALBEDO = vec3(1.0);
	float opacity = sin(lifetime * PI);
	EMISSION = color * intensity * ease * opacity;
	float shape = step(0.04, (sin(UV.x * PI) - UV.y) * UV.y);
	ALPHA = shape * ease * opacity;
}