shader_type canvas_item;

// Uniform to control the pixelation level (higher value = more pixelated)
uniform float pixelation_level : hint_range(1, 256) = 10.0;
uniform sampler2D screen_texture : hint_screen_texture;

void fragment() {
    // Calculate pixel_size based on the screen resolution and pixelation_level
    float pixel_size = max(SCREEN_PIXEL_SIZE.x, SCREEN_PIXEL_SIZE.y) / pixelation_level;

    vec2 uv = SCREEN_UV;
    uv = floor(uv * vec2(pixelation_level)) / vec2(pixelation_level);
    COLOR = texture(screen_texture, uv);
}
