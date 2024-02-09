shader_type particles;
render_mode disable_velocity;
uniform int particles_count = 12;
uniform float tilt = 0.7;
uniform sampler2D curve_sampler : repeat_disable;

#include "res://shared/shaders/hash.gdshaderinc"
#include "res://shared/shaders/rand_from_seed.gdshaderinc"
#include "res://shared/shaders/remap.gdshaderinc"
#include "res://shared/shaders/rotate_y.gdshaderinc"
#include "res://shared/shaders/rotate_z.gdshaderinc"

void start() {
	uint alt_seed1 = hash(NUMBER + uint(1) + RANDOM_SEED);
	uint alt_seed2 = hash(NUMBER + uint(2) + RANDOM_SEED);
	
	CUSTOM.x = rand_from_seed(alt_seed1);
	CUSTOM.y = 0.0;
	
	TRANSFORM = EMISSION_TRANSFORM;
	TRANSFORM *= mat4(rotateZ(tilt) * rotateY(rand_from_seed(alt_seed2) * PI * TAU));
	float percent = float(INDEX) / float(particles_count);
	TRANSFORM *= texture(curve_sampler, vec2(percent, 0.0)).z;
}

void process() {
	CUSTOM.y += DELTA / LIFETIME;
	float lifetime = clamp(CUSTOM.y, 0.0, 1.0);
	vec4 emission_curves = texture(curve_sampler, vec2(lifetime, 0.0));
	
	vec3 rotation_position = vec3(
		0.0,
		remap(emission_curves.x, 0.0, 1.0, -4.5, -0.8),
		0.0) * rotateZ(-tilt);
	
	float percent = float(INDEX) / float(particles_count);
	
	vec3 position = vec3(
		percent * 10.0 + ((CUSTOM.x) - 0.5) * 0.5,
		0.0,
		(CUSTOM.x - 0.5) * (percent + 0.5) * 4.0);
		
	TRANSFORM[3].xyz = position + rotation_position + EMISSION_TRANSFORM[3].xyz;
	
	if(emission_curves.y > 0.8){
		mat4 custom_transform = TRANSFORM;
		custom_transform[3].xyz -= rotation_position;
		custom_transform[3].y = 0.2;
		emit_subparticle(custom_transform, vec3(0.0), vec4(0.0), vec4(0.0), FLAG_EMIT_POSITION);
	}
}
