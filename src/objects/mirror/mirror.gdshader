shader_type spatial;

render_mode unshaded;

uniform sampler2D video_texture;

uniform vec2 mesh_size; // Don't assign, passed from scrip

void fragment()
{
	vec2 uv = vec2(1.0 - UV.x, UV.y);
	vec2 viewport_to_uv_ratio = vec2(
		clamp(VIEWPORT_SIZE.y / VIEWPORT_SIZE.x, 0.0, 1.0),
		clamp(VIEWPORT_SIZE.x / VIEWPORT_SIZE.y, 0.0, 1.0)
	);
	vec2 mesh_ratio = vec2(
		clamp(mesh_size.x / mesh_size.y, 0.0, 1.0),
		clamp(mesh_size.y / mesh_size.x, 0.0, 1.0)
	);
	uv -= vec2(0.5);
	uv *= viewport_to_uv_ratio * mesh_ratio;
	uv += vec2(0.5);
	vec4 color = texture(video_texture, uv);
	ALBEDO = color.rgb;
	ALPHA = color.a;
}