shader_type spatial;

uniform sampler2D voronoi_sampler : filter_linear_mipmap, repeat_enable;
uniform sampler2D gradient_sampler : filter_linear, source_color;

varying float id;
varying vec4 custom;

void vertex() {
	
	mat4 mat_world = mat4(normalize(INV_VIEW_MATRIX[0]), normalize(INV_VIEW_MATRIX[1]) ,normalize(INV_VIEW_MATRIX[2]), MODEL_MATRIX[3]);
	mat_world = mat_world * mat4(vec4(cos(INSTANCE_CUSTOM.x), -sin(INSTANCE_CUSTOM.x), 0.0, 0.0), vec4(sin(INSTANCE_CUSTOM.x), cos(INSTANCE_CUSTOM.x), 0.0, 0.0), vec4(0.0, 0.0, 1.0, 0.0), vec4(0.0, 0.0, 0.0, 1.0));
	MODELVIEW_MATRIX = VIEW_MATRIX * mat_world;
	MODELVIEW_MATRIX = MODELVIEW_MATRIX * mat4(vec4(length(MODEL_MATRIX[0].xyz), 0.0, 0.0, 0.0),vec4(0.0, length(MODEL_MATRIX[1].xyz), 0.0, 0.0), vec4(0.0, 0.0, length(MODEL_MATRIX[2].xyz), 0.0), vec4(0.0, 0.0, 0.0, 1.0));
	MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
	
	id = float(INSTANCE_ID);
	custom = INSTANCE_CUSTOM;
}

void fragment() {
	float voronoi = texture(voronoi_sampler, UV * 0.3 + id * 0.1 + custom.b).x;
	float dist = distance(UV, vec2(0.5));
	float dist_mask = smoothstep(0.45, 0.2, dist);
	float mask = max(0.0, dist_mask - voronoi);
	vec3 gradient = texture(gradient_sampler, vec2(mask, 0.0)).rgb;
	ALBEDO = gradient;
	EMISSION = gradient * 1.4 * (1.0 - custom.y);
	ALPHA = smoothstep(custom.y, custom.y + 0.1, mask) * COLOR.a;
}
