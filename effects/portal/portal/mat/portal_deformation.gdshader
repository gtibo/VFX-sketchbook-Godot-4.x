shader_type spatial;
render_mode cull_front, unshaded, shadows_disabled;

uniform sampler2D noise_sampler : filter_linear_mipmap, repeat_enable;
uniform sampler2D alpha_curve : filter_linear_mipmap, repeat_disable;
uniform vec2 uv_offset;
uniform vec2 uv_scale = vec2(1.0);
uniform float swirl_scale = 1.0;
uniform float time_scale = 0.1;


varying vec3 v;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear_mipmap;

uniform vec2 r_displacement = vec2(3.0, 0.0);
uniform vec2 g_displacement = vec2(0.0, 0.0);
uniform vec2 b_displacement = vec2(-3.0, 0.0);

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
	float t = TIME * time_scale;
	float n_1 = sample_noise(UV, vec2(1.0));
	float n_2 = sample_noise(UV, vec2(0.0, t * 0.5));
	float n = n_1 - (n_2 * 0.1);
	float alpha_c = texture(alpha_curve, vec2(UV.y, 0.0)).x;
	ALPHA *= alpha_c * smoothstep(1.25, 0.8, v.z);
	
	vec2 uv = SCREEN_UV + (n - 0.5) * 0.025 * alpha_c;
	float fade = UV.y;
	float r = texture(screen_texture, uv + vec2(r_displacement) * fade, 0.0).r;
	float g = texture(screen_texture, uv + vec2(g_displacement) * fade, 0.0).g;
	float b = texture(screen_texture, uv + vec2(b_displacement) * fade, 0.0).b;
	
	ALBEDO = vec3(r, g, b);
	}