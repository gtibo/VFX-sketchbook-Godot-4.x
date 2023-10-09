shader_type spatial;
render_mode cull_disabled, shadows_disabled;

uniform sampler2D grid_sampler : filter_linear_mipmap, repeat_enable;
uniform sampler2D depth_texture_sampler : hint_depth_texture;
uniform vec3 base_color : source_color;

float fresnel(float amount, vec3 normal, vec3 view)
{
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0 )), amount);
}

void vertex() {
	float wave = ((1.0 + sin((UV.y + TIME * 0.1) * PI * 4.0)) * 0.5);
	VERTEX += NORMAL * wave * 0.01;
}

void fragment() {
	float depth_texture = textureLod(depth_texture_sampler, SCREEN_UV, 0.0).r;
	vec4 world_pos = INV_PROJECTION_MATRIX * vec4(SCREEN_UV * 2.0 - 1.0,depth_texture, 1.0);
	world_pos.xyz /= world_pos.w;
	
	float f = fresnel(1.0, NORMAL, VIEW);
	float edge = clamp(smoothstep(world_pos.z + 0.1, world_pos.z, VERTEX.z)
		+ fresnel(3.0, NORMAL, VIEW), 0.0, 1.0);
	float height_mask = smoothstep(0.8, 1.0, sin(UV.y * PI));
	vec2 hex_color = texture(grid_sampler, (UV + vec2(0.0, TIME * 0.01)) * vec2(2.0, 1.0) * 2.0).xy;
	float hex_edge = min(edge, hex_color.x) * height_mask;
	float hex_fill = smoothstep(0.01, 0.0,
		(sin(hex_color.y * 10.0 + TIME * 0.1) + 1.0) * 0.5) * height_mask * (1.0 - hex_color.x);
	float wave = step(sin((UV.y + TIME * 0.04) * 8.0 * PI), 0.0);
	
	ROUGHNESS = 1.0;
	SPECULAR = 0.0;
	ALBEDO = base_color;
	EMISSION = base_color * 2.0 + min(1.0, edge + hex_fill * 1.2 + wave * 0.4) * f;
	ALPHA = clamp(edge + hex_fill * 0.4 + 0.02 + wave * 0.1 + hex_edge, 0.0, 1.0) * f;
}
