shader_type spatial;
render_mode unshaded;

uniform sampler2D gradient : repeat_disable;

void fragment() {
	ALPHA = texture(gradient, vec2(distance(UV, vec2(0.5)) * 2.0, 0.0)).x * COLOR.a;
	EMISSION = vec3(1.0) * 2.0;
}