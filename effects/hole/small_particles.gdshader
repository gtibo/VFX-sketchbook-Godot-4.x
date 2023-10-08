shader_type spatial;

uniform vec3 color : source_color;
uniform float intensity = 1.0;
varying vec4 custom;

void vertex() {
	custom = INSTANCE_CUSTOM;
}

void fragment() {
	float offset = (sin(custom.z) + 1.0) * 0.8;
	ALBEDO = color;
	EMISSION = color * intensity * offset;
	ALPHA = smoothstep(0.5, 0.0, distance(UV, vec2(0.5))) * COLOR.a;
}