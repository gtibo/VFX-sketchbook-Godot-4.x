shader_type spatial;
render_mode shadows_disabled;

uniform float intensity = 1.0;
uniform sampler2D intensity_gradient : filter_linear;
uniform sampler2D gradient : source_color, filter_linear;

void fragment() {
	vec3 color = texture(gradient, vec2(UV.y, 0.0)).rgb;
	ALBEDO = color;
	EMISSION = color * intensity * texture(intensity_gradient, vec2(UV.y, 0.0)).rgb;
}
