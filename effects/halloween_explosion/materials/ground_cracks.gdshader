shader_type spatial;

uniform sampler2D cracks_sampler : filter_linear_mipmap_anisotropic, repeat_disable; 
uniform vec3 light_color : source_color;
uniform float intensity = 1.0;
uniform float progress : hint_range(0.0, 1.0, 0.1) = 0.5;
uniform float alpha : hint_range(0.0, 1.0, 0.1) = 1.0;


void fragment() {
	vec2 cracks_data = texture(cracks_sampler, UV).xy;
	float s = smoothstep(progress - 0.1, progress + 0.1, cracks_data.x);
	ALBEDO = mix(light_color, vec3(0.0), s);
	EMISSION = light_color * (1.0 - s) * intensity;
	ALPHA = cracks_data.y * alpha;
}
