shader_type canvas_item;

uniform vec2 scroll_offset = vec2(0.0, 0.0);
uniform vec2 size = vec2(256.0, 320.0);

uniform sampler2D bg_image;

void fragment(){
	
	vec2 st = UV;
	st.x *= size.x/size.y;
	
	
	vec2 bg_uv = st;
	bg_uv.y += scroll_offset.y/size.y;
	vec4 bg = texture(bg_image, bg_uv);
	
	COLOR = bg;
}