
shader_type canvas_item;

uniform float time : hint_range(0, 10);


void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
	FRAGCOORD

    // Make the sprite color change over time
    float color_shift = sin(TIME + time);
    COLOR = vec4(tex_color.rgb * vec3(1.0 + color_shift, 1.0, 1.0 - color_shift), tex_color.a);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
