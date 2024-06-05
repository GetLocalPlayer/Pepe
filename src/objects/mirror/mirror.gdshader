shader_type spatial;

render_mode unshaded;

uniform sampler2D video_texture;

void fragment() {
	vec4 color = texture(video_texture, SCREEN_UV);
	ALBEDO = color.rgb;
	ALPHA = color.a;
}