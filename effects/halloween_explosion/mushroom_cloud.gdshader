shader_type spatial;
render_mode cull_disabled;

uniform sampler2D height_curve_sampler : filter_linear, repeat_disable;
uniform sampler2D voronoi_sampler : filter_linear_mipmap, repeat_enable;
uniform sampler2D face_sampler : filter_linear_mipmap, repeat_disable;
uniform float face_intensity = 1.0;
varying float voronoi;

uniform vec3 light_color : source_color;
uniform vec3 smoke_color : source_color;

uniform float voronoi_offset = 0.0;

group_uniforms deformations;
uniform float deformation_amount : hint_range(0.0, 1.0, 0.1) = 1.0;
uniform float head_grow = 0.0;
uniform float head_elevation = 0.0;

group_uniforms light;
uniform float light_intensity : hint_range(0.0, 2.0, 0.1) = 1.0;
uniform float light_progress : hint_range(0.0, 1.0, 0.1) = 0.0;
uniform float alpha_progress : hint_range(0.0, 1.0, 0.1) = 0.0;
uniform float smooth_amount = 0.2;

// https://godotshaders.com/snippet/fresnel/
float fresnel(float amount, vec3 normal, vec3 view)
{
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0 )), amount);
}

// https://gist.github.com/companje/29408948f1e8be54dd5733a74ca49bb9
float map(float value, float min1, float max1, float min2, float max2) {
	return min2 + (value - min1) * (max2 - min2) / (max1 - min1);
}

void vertex() {
	vec4 height_curve = texture(height_curve_sampler, vec2(UV.y, 0.0));
	voronoi = texture(voronoi_sampler, UV * vec2(1.0, 0.5) + vec2(0.0, -voronoi_offset)).x;
	VERTEX += NORMAL * height_curve.x * head_grow;
	VERTEX += vec3(0.0, 1.0, 0.0) * height_curve.y * head_elevation;
	VERTEX += NORMAL * (1.0 - voronoi) * deformation_amount * height_curve.z;
}

void fragment() {
	float v = texture(voronoi_sampler, UV * vec2(1.0, 0.5) + vec2(0.0, -voronoi_offset)).x;
	//ALPHA = v;
	// ALBEDO = mix(light_color, smoke_color, v);
	float fresnel_mask = step(0.8, fresnel(1.0, NORMAL, VIEW));
	
	float map_light_progress = map(light_progress, 0.0, 1.0, -smooth_amount, 1.0 + smooth_amount);
	
	float light_mask = clamp(smoothstep(map_light_progress - smooth_amount, map_light_progress + smooth_amount, 1.0 - v), 0.0, 1.0);
	float face = texture(face_sampler, (UV - vec2(0.5, 0.3)) * vec2(1.0, 0.8) * 4.0 + 0.5).x;
	
	float map_alpha_progress = map(alpha_progress, 0.0, 1.0, -smooth_amount, 1.0 + smooth_amount);
	float alpha_mask = clamp(smoothstep(map_alpha_progress - smooth_amount, map_alpha_progress + smooth_amount, 1.0 - v), 0.0, 1.0);
	
	SPECULAR = 0.1;
	ROUGHNESS = 0.9;
	ALBEDO = mix(smoke_color, light_color, light_mask);
	EMISSION =
	(light_color * light_mask + fresnel_mask * light_color) * light_intensity  
	+ face * light_color * face_intensity
	;
	ALPHA = min(1.0, alpha_mask);
	ALPHA_SCISSOR_THRESHOLD = 0.5;
}
