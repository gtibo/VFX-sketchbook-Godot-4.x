shader_type spatial;

uniform sampler2D voronoi_sampler : filter_linear_mipmap, repeat_enable;

uniform float mix_blend : hint_range(0.0, 1.0, 0.1) = 0.2;
uniform float mix_voronoi : hint_range(0.0, 1.0, 0.1) = 0.2;

uniform float progress : hint_range(0.0, 1.0, 0.1);

void fragment() {
	float voronoi = texture(voronoi_sampler, UV * vec2(3.0, 1.0) * 0.25).x;
	float dist = clamp(sin(UV.x * PI) * sin(UV.y * PI), 0.0, 1.0);
	float progress_mask = smoothstep(progress + 0.2, progress - 0.2, UV.x);
	SPECULAR = 0.0;
	ALBEDO.rgb = vec3(0.0);
	ALPHA = smoothstep(0.0, 0.1, (dist - (voronoi * mix_voronoi)) * mix_blend * progress_mask) * 0.4 * mix_blend;
}
