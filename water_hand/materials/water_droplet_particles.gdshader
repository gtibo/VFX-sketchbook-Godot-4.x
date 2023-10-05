shader_type spatial;
render_mode cull_disabled;

uniform sampler2D atlas_sampler : filter_linear_mipmap, repeat_disable;
uniform sampler2D voronoi_sampler : filter_linear_mipmap, repeat_enable;
varying vec4 custom;
varying float id;

void vertex() {
	custom = INSTANCE_CUSTOM;
	id = float(INSTANCE_ID);
}

void fragment() {
	float voronoi = texture(voronoi_sampler, (UV - vec2(0.0, TIME * 4.0 + id * 0.1)) * 0.1).x;
	float mask = texture(atlas_sampler, UV).x;
	ALBEDO = COLOR.rgb;
	EMISSION = ALBEDO * 1.25 + smoothstep(0.0, 0.01, 1.0 - (1.0 + sin(id * 0.2 + TIME * 10.0)));
	ALPHA = smoothstep(custom.y, custom.y + 0.1, mask - voronoi) * COLOR.a;
}
