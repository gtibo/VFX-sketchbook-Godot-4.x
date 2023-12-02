shader_type spatial;
render_mode diffuse_lambert_wrap, specular_disabled;

uniform sampler2D checkerboard_sampler : filter_linear_mipmap_anisotropic, repeat_enable;
uniform vec3 albedo_color : source_color;
uniform float uv_scale = 20.0;

void fragment() {
	ALBEDO = albedo_color * (texture(checkerboard_sampler, UV * uv_scale).x * 0.2 + 0.8);
}
