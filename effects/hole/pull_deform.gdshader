shader_type spatial;
render_mode world_vertex_coords;

uniform float pull_intensity : hint_range(0.0, 1.0, 0.1) = 1.0;

void vertex() {
	vec3 world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	vec3 target = vec3(0.0, min(-2.0, NODE_POSITION_WORLD.y) , 0.0);
	vec3 diff = VERTEX - target;
	VERTEX -=  ( diff ) * pull_intensity * (1.0 - (VERTEX.y - NODE_POSITION_WORLD.y + 0.25));
}

