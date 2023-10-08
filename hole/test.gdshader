shader_type spatial;
render_mode unshaded;

uniform sampler2D voronoi_sampler : hint_default_black, filter_linear_mipmap_anisotropic, repeat_enable;

uniform float opening : hint_range(0.0, 1.0, 0.1) = 1.0;

uniform sampler2D screen_texture_sampler : filter_linear_mipmap, hint_screen_texture;

uniform float heightmap_scale;
uniform int heightmap_min_layers;
uniform int heightmap_max_layers;
uniform vec2 heightmap_flip;
uniform float time_offset = 0.0;

vec2 polar_coordinates(vec2 uv, vec2 center, float zoom, float repeat)
{
	vec2 dir = uv - center;
	float radius = length(dir) * 2.0;
	float angle = atan(dir.y, dir.x) * 1.0/(3.1416 * 2.0);
	return mod(vec2(radius * zoom, angle * repeat), 1.0);
}

float swirl(vec2 uv, float size, int arms, float t)
{
	float angle = atan(-uv.y + 0.5, uv.x - 0.5) + t;
	float len = length(uv - vec2(0.5, 0.5));
	
	return sin(len * size + angle * float(arms));
}

float overlay(float base, float blend){
	float limit = step(0.5, base);
	return mix(2.0 * base * blend, 1.0 - 2.0 * (1.0 - base) * (1.0 - blend), limit);
}

float get_depth(vec2 depth_uv) {
	
	float s = swirl(depth_uv, 8.0, 1,- time_offset * 0.4);
	vec2 uv = polar_coordinates(depth_uv, vec2(0.5), 1.0, 1.0);
	
	float voronoi = texture(voronoi_sampler, vec2(uv.x + time_offset * 0.4, s) * 0.6).x;
	
	float dist = distance(vec2(0.5), depth_uv) * 2.0;
	float edge = smoothstep(opening - 0.5, opening, dist);
	float outter_edge = smoothstep(opening - 0.9, opening, dist);
	
	return max(0.0, (1.0 - edge) - voronoi * outter_edge);
}

void fragment() {
	
	vec2 base_uv = UV;
	{
		vec3 view_dir = normalize(normalize(-VERTEX + EYE_OFFSET) * mat3(TANGENT * heightmap_flip.x, -BINORMAL * heightmap_flip.y, NORMAL));
		float num_layers = mix(float(heightmap_max_layers),float(heightmap_min_layers), abs(dot(vec3(0.0, 0.0, 1.0), view_dir)));
		float layer_depth = 1.0 / num_layers;
		float current_layer_depth = 0.0;
		vec2 P = view_dir.xy * heightmap_scale * 0.01;
		vec2 delta = P / num_layers;
		vec2 ofs = base_uv;
		float depth = get_depth(ofs);
		float current_depth = 0.0;
		while(current_depth < depth) {
			ofs -= delta;
			depth = get_depth(ofs);
			current_depth += layer_depth;
		}
		vec2 prev_ofs = ofs + delta;
		float after_depth  = depth - current_depth;
		float before_depth = (  get_depth(prev_ofs)  ) - current_depth + layer_depth;
		float weight = after_depth / (after_depth - before_depth);
		ofs = mix(ofs,prev_ofs,weight);
		base_uv=ofs;
	}
	float mask = get_depth(base_uv);
	vec4 screen_texture = texture(screen_texture_sampler, SCREEN_UV);
	ALBEDO.rgb = mix(vec3(0.0), screen_texture.rgb, screen_texture.a);
	ALPHA = mask;
}
