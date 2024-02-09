shader_type spatial;

uniform sampler2D depth_texture_sampler : hint_depth_texture;
uniform sampler2D noise_sampler : filter_linear_mipmap, repeat_enable;
varying vec4 custom;
uniform vec3 albedo : source_color;

void vertex() {
	
	mat4 mat_world = mat4(normalize(INV_VIEW_MATRIX[0]), normalize(INV_VIEW_MATRIX[1]) ,normalize(INV_VIEW_MATRIX[2]), MODEL_MATRIX[3]);
	mat_world = mat_world * mat4(vec4(cos(INSTANCE_CUSTOM.x), -sin(INSTANCE_CUSTOM.x), 0.0, 0.0), vec4(sin(INSTANCE_CUSTOM.x), cos(INSTANCE_CUSTOM.x), 0.0, 0.0), vec4(0.0, 0.0, 1.0, 0.0), vec4(0.0, 0.0, 0.0, 1.0));
	MODELVIEW_MATRIX = VIEW_MATRIX * mat_world;
	MODELVIEW_MATRIX = MODELVIEW_MATRIX * mat4(vec4(length(MODEL_MATRIX[0].xyz), 0.0, 0.0, 0.0),vec4(0.0, length(MODEL_MATRIX[1].xyz), 0.0, 0.0), vec4(0.0, 0.0, length(MODEL_MATRIX[2].xyz), 0.0), vec4(0.0, 0.0, 0.0, 1.0));
	MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
	
	custom = INSTANCE_CUSTOM;
}

void fragment() {
	float depth_texture = textureLod(depth_texture_sampler, SCREEN_UV, 0.0).r;
	vec4 world_pos = INV_PROJECTION_MATRIX * vec4(SCREEN_UV * 2.0 - 1.0,depth_texture, 1.0);
	world_pos.xyz /= world_pos.w;
	
	float edge = 1.0 - smoothstep(world_pos.z + 2.0, world_pos.z, VERTEX.z);
	
	float dist = clamp(1.0 - distance(UV, vec2(0.5)) * 2.0, 0.0, 1.0);
	float noise = texture(noise_sampler, (UV + custom.x) * 0.15 + vec2(0.0, TIME * 0.05)).x;
	ALBEDO = albedo;
	SPECULAR = 0.0;
	ALPHA = noise * dist * COLOR.a * edge;
}