shader_type canvas_item;

void fragment() {
    float wave = sin(TIME * 2.0) * 0.5 + 0.5;  // Generates a wave between 0 and 1
    wave = pow(wave, 10.0); // Sharpens the wave, making the effect more subtle

    float alpha = wave * 0.5; // Controls the maximum opacity of the effect

    COLOR = vec4(0.0, 0.0, 0.0, alpha); // Applies the black color with calculated opacity
}
