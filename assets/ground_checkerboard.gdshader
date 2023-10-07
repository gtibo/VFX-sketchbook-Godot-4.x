shader_type spatial;
render_mode diffuse_lambert_wrap, specular_disabled, depth_draw_always;

uniform sampler2D checkerboard_sampler : filter_linear_mipmap_anisotropic, repeat_enable;
uniform vec3 albedo_color : source_color;

void fragment() {
	ALBEDO = albedo_color * (texture(checkerboard_sampler, UV * 10.0).x * 0.2 + 0.8);
	ALPHA *= smoothstep(1.0, 0.4, distance(UV, vec2(0.5)) * 2.0);
}
