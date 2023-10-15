shader_type spatial;
render_mode cull_disabled, particle_trails;

uniform sampler2D gradient_sampler : filter_linear;

void fragment() {
	vec3 gradient = texture(gradient_sampler, vec2(UV.y, 0.0)).rgb;
	float mask = (1.0 - UV.y);
	ALBEDO = gradient;
	EMISSION = gradient * 3.0 * mask * COLOR.a;
	ALPHA = step(0.2, sin(UV.x * PI) * sin(UV.y * PI)) * mask * COLOR.a;
}
