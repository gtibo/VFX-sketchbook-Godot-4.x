shader_type spatial;
render_mode cull_disabled;

uniform sampler2D gradient_sampler : filter_linear;

void fragment() {
	vec3 gradient = texture(gradient_sampler, vec2(UV.y, 0.0)).rgb;
	float mask = (1.0 - UV.y);
	ALBEDO = gradient;
	EMISSION = gradient * 2.5 * mask * COLOR.a;
	ALPHA = step(0.2, sin(UV.x * PI) * sin(UV.y * PI)) * mask * COLOR.a;
}
