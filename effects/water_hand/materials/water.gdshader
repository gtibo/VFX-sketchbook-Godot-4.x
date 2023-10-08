shader_type spatial;
render_mode cull_back, depth_draw_always;

uniform sampler2D depth_texture_sampler : hint_depth_texture;
uniform sampler2D voronoi_sampler : filter_linear_mipmap, repeat_enable;
uniform sampler2D caustic_sampler : filter_linear_mipmap, repeat_enable;

uniform vec3 base_color : source_color;
uniform vec3 dark_color : source_color;

varying vec3 uv1_triplanar_pos;
uniform float uv1_blend_sharpness;
varying vec3 uv1_power_normal;
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;

float fresnel(float amount, vec3 normal, vec3 view)
{
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0 )), amount);
}

vec2 polar_coordinates(vec2 uv, vec2 center, float zoom, float repeat)
{
	vec2 dir = uv - center;
	float radius = length(dir) * 2.0;
	float angle = atan(dir.y, dir.x) * 1.0/(3.1416 * 2.0);
	return mod(vec2(radius * zoom, angle * repeat), 1.0);
}

void vertex() {
	
	TANGENT = vec3(0.0,0.0,-1.0) * abs(NORMAL.x);
	TANGENT+= vec3(1.0,0.0,0.0) * abs(NORMAL.y);
	TANGENT+= vec3(1.0,0.0,0.0) * abs(NORMAL.z);
	TANGENT = normalize(TANGENT);
	BINORMAL = vec3(0.0,1.0,0.0) * abs(NORMAL.x);
	BINORMAL+= vec3(0.0,0.0,-1.0) * abs(NORMAL.y);
	BINORMAL+= vec3(0.0,1.0,0.0) * abs(NORMAL.z);
	BINORMAL = normalize(BINORMAL);
	
	uv1_power_normal=pow(abs(NORMAL),vec3(uv1_blend_sharpness));
	uv1_triplanar_pos = VERTEX * uv1_scale + uv1_offset;
	uv1_power_normal/=dot(uv1_power_normal,vec3(1.0));
	uv1_triplanar_pos *= vec3(1.0,-1.0, 1.0);
	
	float wave = sin((uv1_triplanar_pos.y - TIME * 0.8) * PI * 4.0);
	VERTEX += NORMAL * wave * 0.01;
}

vec4 triplanar_texture(sampler2D p_sampler,vec3 p_weights,vec3 p_triplanar_pos) {
	vec4 samp = vec4(0.0);
	samp += texture(p_sampler,p_triplanar_pos.xy) * p_weights.z;
	samp += texture(p_sampler,p_triplanar_pos.xz) * p_weights.y;
	samp += texture(p_sampler,p_triplanar_pos.zy * vec2(-1.0,1.0)) * p_weights.x;
	return samp;
}

void fragment() {
	float depth_texture = textureLod(depth_texture_sampler, SCREEN_UV, 0.0).r;
	vec4 world_pos = INV_PROJECTION_MATRIX * vec4(SCREEN_UV * 2.0 - 1.0,depth_texture, 1.0);
	world_pos.xyz /= world_pos.w;
	
	float big_noise = triplanar_texture(caustic_sampler, uv1_power_normal, (uv1_triplanar_pos - vec3(TIME, 0.0, 0.0) * 0.2) * 0.8).x;
	float small_noise = triplanar_texture(caustic_sampler, uv1_power_normal, (uv1_triplanar_pos - vec3(TIME, 0.0, 0.0) * 0.1) * 1.2).x;
	
	float voronoi = triplanar_texture(voronoi_sampler, uv1_power_normal, (uv1_triplanar_pos - vec3(TIME, 0.0, 0.0) * 0.2) * 0.8).x;
	
	float noise = mix(small_noise, big_noise, 0.85);
	
	float small_edge = smoothstep(world_pos.z + 0.1, world_pos.z, VERTEX.z);
	float big_edge = smoothstep(world_pos.z + 2.0, world_pos.z, VERTEX.z);
	float bottom_mask = clamp((1.0 - small_edge) - voronoi * big_edge, 0.0, 1.0);
	
	float f = fresnel(1.0, NORMAL, VIEW);
	ALBEDO = mix(dark_color, base_color, max(0.0, step(0.35, f) + noise)) + step(0.6, f + (1.0 - bottom_mask)) * 0.4;
	EMISSION = ALBEDO * f;
	ALPHA = bottom_mask;
	ALPHA_SCISSOR_THRESHOLD = 0.5;
}
