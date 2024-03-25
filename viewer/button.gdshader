shader_type canvas_item;

uniform float scale : hint_range(0.0, 1.0, 0.1) = 1.0;
uniform float greyscale : hint_range(0.0, 1.0, 0.1) = 0.0;

void fragment() {
	vec3 color = texture(TEXTURE, (UV - 0.5) * scale + 0.5).rgb;
	float g = dot(color, vec3(0.299, 0.587, 0.114));
	COLOR.rgb = mix(color, vec3(g), greyscale);
}