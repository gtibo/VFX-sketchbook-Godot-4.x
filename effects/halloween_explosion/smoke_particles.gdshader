shader_type spatial;
render_mode unshaded;

uniform sampler2D depth_texture_sampler : hint_depth_texture;
uniform sampler2D voronoi_sampler : filter_linear_mipmap, repeat_enable;
uniform sampler2D gradient_sampler : filter_linear, source_color;
uniform float smoothness : hint_range(0.0, 1.0, 0.1) = 0.4;

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
	float depth_texture = textureLod(depth_texture_sampler, SCREEN_UV, 0.0).r;
	vec4 world_pos = INV_PROJECTION_MATRIX * vec4(SCREEN_UV * 2.0 - 1.0,depth_texture, 1.0);
	world_pos.xyz /= world_pos.w;
	
	float edge = 1.0 - smoothstep(world_pos.z + 2.0, world_pos.z, VERTEX.z);
	
	float voronoi = texture(voronoi_sampler, UV * 0.25 + id * 0.25 + vec2(0.0, TIME * 0.04)).x;
	float dist = distance(UV, vec2(0.5));
	float dist_mask = smoothstep(0.45, 0.0, dist);
	float mask = max(0.0, dist_mask - voronoi);
	vec4 gradient = texture(gradient_sampler, vec2(voronoi, 0.0));
	ALBEDO = gradient.rgb;
	SPECULAR = 0.0;
	ALPHA = smoothstep(max(0.0, custom.y - smoothness), min(1.0, custom.y + smoothness), mask) * COLOR.a * edge;
}