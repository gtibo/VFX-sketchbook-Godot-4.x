shader_type particles;

uniform sampler2D curve_sampler : repeat_disable;
uniform float min_scale = 0.5;
uniform float max_scale = 1.2;
uniform int particles_count = 128;
uniform float zone_length = 10.0;

#include "res://shared/shaders/hash.gdshaderinc"
#include "res://shared/shaders/rand_from_seed.gdshaderinc"
#include "res://shared/shaders/remap.gdshaderinc"

void start() {
	uint alt_seed1 = hash(NUMBER + uint(1) + RANDOM_SEED);
	uint alt_seed2 = hash(NUMBER + uint(10) + RANDOM_SEED);
	uint alt_seed3 = hash(NUMBER + uint(20) + RANDOM_SEED);
	uint alt_seed4 = hash(NUMBER + uint(30) + RANDOM_SEED);
	
	CUSTOM.x = rand_from_seed(alt_seed1);
	
	CUSTOM.y = 0.0;
	TRANSFORM = EMISSION_TRANSFORM;
	
	float percent = float(INDEX) / float(particles_count);
	float shape = texture(curve_sampler, vec2(percent, 0.0)).z;
	
	vec3 position = vec3(
		shape * 10.0,
		0.0,
		(CUSTOM.x - 0.5) * 4.5) * percent;
		
	TRANSFORM[3].xyz = position + EMISSION_TRANSFORM[3].xyz;
	VELOCITY.x = (rand_from_seed(alt_seed2) - 0.5) * 0.5;
	VELOCITY.y = rand_from_seed(alt_seed3) * 0.5;
	VELOCITY.z = (rand_from_seed(alt_seed4) - 0.5) * 0.5;
	VELOCITY = VELOCITY;
}

void process() {
	float percent = float(INDEX) / float(particles_count);
	CUSTOM.y += DELTA / LIFETIME;
	vec3 curve = texture(curve_sampler, vec2(CUSTOM.y, 0.0)).xyz;
	COLOR.a = curve.x;
	VELOCITY *= 0.99;
	
	float scale = remap(CUSTOM.x, 0.0, 1.0, min_scale, max_scale);
	TRANSFORM[0] = EMISSION_TRANSFORM[0] * scale * curve.y;
	TRANSFORM[1] = EMISSION_TRANSFORM[1] * scale * curve.y;
	TRANSFORM[2] = EMISSION_TRANSFORM[2] * scale * curve.y;
}
