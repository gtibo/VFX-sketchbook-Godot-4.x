shader_type spatial;
render_mode cull_front;

uniform sampler2D splash_mask : filter_linear_mipmap, repeat_enable;
uniform vec3 base_color : source_color;

uniform float progress : hint_range(0.1, 1.0, 0.01) = 0.5;

float fresnel(float amount, vec3 normal, vec3 view)
{
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0 )), amount);
}


void fragment() {
	vec2 def_uv = vec2(UV.x, clamp(UV.y - abs(sin(UV.x * PI * 1.0)) * 0.3, 0.05, 1.0) );
	float mask_value = texture(splash_mask, def_uv * vec2(3.0, 1.0)).x;
	ALPHA = smoothstep(progress, progress + 0.02, mask_value) * clamp((1.0 - UV.y) * 1.25, 0.0, 1.0) * (1.0 - fresnel(2.0, NORMAL, VIEW));
	float foam_mask = step(UV.y * mask_value, 0.2);
	ALBEDO = base_color + foam_mask;
	EMISSION = base_color * 1.25;
}
