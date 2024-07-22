shader_type spatial;
render_mode cull_front, shadows_disabled;

uniform sampler2D noise_sampler : filter_linear_mipmap, repeat_enable;
uniform sampler2D noise_edge : filter_linear_mipmap, repeat_disable;
uniform sampler2D alpha_curve : filter_linear_mipmap, repeat_disable;
uniform vec2 uv_offset;
uniform vec2 uv_scale = vec2(1.0);
uniform float swirl_scale = 1.0;
uniform float time_scale = 0.1;

uniform sampler2D albedo_gradient : source_color;

varying vec3 v;

float sample_noise(vec2 uv, vec2 offset){
	float t = TIME * time_scale;
	uv += uv_offset;
	uv.x += uv.y * swirl_scale;
	uv.y += -t;
	uv *= uv_scale;
	uv += offset;
	return texture(noise_sampler, uv).x;
}

void vertex() {
	v = VERTEX.xyz;
}

void fragment() {
	vec3 n_edge = texture(noise_edge, vec2(UV.y, 0.0)).xyz;
	float t = TIME * time_scale;
	float n_1 = sample_noise(UV, vec2(1.0));
	float n_2 = sample_noise(UV, vec2(0.0, t * 0.5));
	float n = n_1 - (n_2 * 0.1);
	ALPHA = smoothstep(0.0, n_edge.z, max(0.0, n_edge.x - n)) * texture(alpha_curve, vec2(UV.y, 0.0)).x;
	ALBEDO = texture(albedo_gradient, vec2(n_2, 0.0)).rgb;
	EMISSION = ALBEDO * n_edge.y * (1.0 - n * n_edge.z);
	ALPHA *= smoothstep(1.25, 0.8, v.z);
}