shader_type particles;

#include "res://shared/shaders/noise_2d.gdshaderinc"

uniform sampler2D noise_sampler : repeat_enable, filter_linear;

float rand_from_seed(in uint seed) {
	int k;
	int s = int(seed);
	if (s == 0) s = 305420679;
	k = s / 127773;
	s = 16807 * (s - k * 127773) - 2836 * k;
	if (s < 0) s += 2147483647;
	seed = uint(s);
	return float(seed % uint(65536)) / 65535.0;
}

uint hash(uint x) {
	x = ((x >> uint(16)) ^ x) * uint(73244475);
	x = ((x >> uint(16)) ^ x) * uint(73244475);
	x = (x >> uint(16)) ^ x;
	return x;
}

void start() {
	uint alt_seed1 = hash(INDEX);
	CUSTOM.x = rand_from_seed(alt_seed1) * 2.0 - 1.0;
	CUSTOM.y = 0.0;
	TRANSFORM = EMISSION_TRANSFORM;
	VELOCITY = vec3(0.0);
}

void process() {
	CUSTOM.y += DELTA / LIFETIME;
	float t = CUSTOM.y + CUSTOM.x;
	float x = texture(noise_sampler, vec2(t, CUSTOM.x)).x * 2.0 - 1.0;
	float y = texture(noise_sampler, vec2(t, t)).x * 2.0 - 1.0;
	float z = texture(noise_sampler, vec2(CUSTOM.x, t)).x * 2.0 - 1.0;
	TRANSFORM[3].x = x * 4.0;
	TRANSFORM[3].y = y * 0.25 + sin((t * TAU + CUSTOM.x) * 4.0) * 0.1;
	TRANSFORM[3].z = z * 4.0;
	TRANSFORM[3] += EMISSION_TRANSFORM[3];
}
