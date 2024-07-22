shader_type spatial;
render_mode unshaded;

uniform sampler2D viewport_sampler : filter_linear, source_color;

void fragment(){
	float dist = distance(UV, vec2(0.5));
	vec3 viewport_texture = texture(viewport_sampler, SCREEN_UV).rgb;
	ALBEDO = viewport_texture * 0.58;
	ALPHA = step(dist, 0.5);
	ALPHA_SCISSOR_THRESHOLD = 0.5;
}