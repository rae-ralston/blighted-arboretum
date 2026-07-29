shader_type canvas_item;

uniform float speed = 0.3;
uniform float pulse_width = 0.3;
uniform float progress = 1.0;

void fragment() {
	if (UV.x > progress) {
		discard;
	} else {
		vec4 base_color = vec4(1.0, 0.7, 0.1, 1.0);
		vec4 pulse_color = vec4(1.0, 0.95, 0.6, 1.0);
		float t = fract(UV.x - TIME * speed);
		float pulse = 1.0 - smoothstep(0.0, pulse_width, t);
		COLOR = mix(base_color, pulse_color, pulse);
	}
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
