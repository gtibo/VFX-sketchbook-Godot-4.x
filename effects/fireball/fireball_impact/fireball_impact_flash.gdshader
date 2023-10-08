shader_type spatial;
render_mode ambient_light_disabled;

uniform vec3 base_color : source_color;
uniform sampler2D gradient_sampler : filter_linear;

uniform float alpha = 1.0;
uniform float intensity = 1.0;
uniform float scale = 1.0;

vec2 polar_coordinates(vec2 uv, vec2 center, float zoom, float repeat)
{
	vec2 dir = uv - center;
	float radius = length(dir) * 2.0;
	float angle = atan(dir.y, dir.x) * 1.0/(3.1416 * 2.0);
	return mod(vec2(radius * zoom, angle * repeat), 1.0);
}

void vertex() {
	
	mat4 mat_world = mat4(normalize(INV_VIEW_MATRIX[0]), normalize(INV_VIEW_MATRIX[1]) ,normalize(INV_VIEW_MATRIX[2]), MODEL_MATRIX[3]);
	mat_world = mat_world * mat4(vec4(cos(INSTANCE_CUSTOM.x), -sin(INSTANCE_CUSTOM.x), 0.0, 0.0), vec4(sin(INSTANCE_CUSTOM.x), cos(INSTANCE_CUSTOM.x), 0.0, 0.0), vec4(0.0, 0.0, 1.0, 0.0), vec4(0.0, 0.0, 0.0, 1.0));
	MODELVIEW_MATRIX = VIEW_MATRIX * mat_world;
	MODELVIEW_MATRIX = MODELVIEW_MATRIX * mat4(vec4(length(MODEL_MATRIX[0].xyz), 0.0, 0.0, 0.0),vec4(0.0, length(MODEL_MATRIX[1].xyz), 0.0, 0.0), vec4(0.0, 0.0, length(MODEL_MATRIX[2].xyz), 0.0), vec4(0.0, 0.0, 0.0, 1.0));
	MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
	VERTEX *= scale;
}

void fragment() {
	vec2 p_uv = polar_coordinates(UV, vec2(0.5), 1.0, 1.0);
	float spikes = texture(gradient_sampler, vec2((p_uv.y * 8.0), 0.5)).x;
	float spikes_offset = texture(gradient_sampler, vec2(p_uv.y, 0.5)).y;
	
	float wave = (spikes * 0.1 + 0.25) * spikes_offset;
	float shape = max(0.0, distance(UV, vec2(0.5)) - wave);
	ALPHA *= smoothstep(0.1, 0.0, shape) * alpha;
	ALBEDO = base_color;
	EMISSION = base_color * intensity;
}
