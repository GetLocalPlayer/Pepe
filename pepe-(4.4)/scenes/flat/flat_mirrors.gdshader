shader_type spatial;

render_mode unshaded;

uniform sampler2D video_texture;
uniform sampler2D ramp;

void fragment() {
	vec4 color = texture(video_texture, SCREEN_UV);
	float bigger = max(color.r, color.g);
	bigger = max(bigger, color.b);
	ALBEDO = color.rgb * texture(ramp, vec2(bigger)).rgb;
	ALPHA = color.a;
}