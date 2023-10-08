shader_type spatial;

uniform sampler2D voronoi_sampler : filter_linear_mipmap, repeat_enable;

varying vec4 custom;

void vertex() {
	custom = INSTANCE_CUSTOM;
}

void fragment() {
	float voronoi = texture(voronoi_sampler, UV * 0.3 + custom.z).x;
	float dist = distance(UV, vec2(0.5));
	ALPHA = smoothstep(0.52, 0.48, dist + voronoi * 0.1) * COLOR.a;
	ALBEDO = COLOR.rgb;
	EMISSION = ALBEDO;
}
