shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float opacity = 0.0;

void fragment() {
    vec4 tex_color = textureLod(screen_texture, SCREEN_UV, 0.0);
	
    // Calculate the brightness of the pixel
    float brightness = (tex_color.r + tex_color.g + tex_color.b) / 3.0;
	
	// Set the color to shades of red and black based on the brightness
    vec4 red_black = vec4(brightness, 0.0, 0.0, 1.0);

    // Blend the original color and the red_black color based on opacity
    COLOR = mix(tex_color, red_black, opacity);
}