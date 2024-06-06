shader_type spatial;

render_mode unshaded;

uniform sampler2D video_texture;

void fragment() {
	vec2 uv = vec2(1.0 - UV.x, UV.y);
	vec4 color = texture(video_texture, uv);
	ALBEDO = color.rgb;
	ALPHA = color.a;
}