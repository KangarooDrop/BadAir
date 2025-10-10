shader_type canvas_item;

uniform float t : hint_range(0.0, 1.0, 0.05) = 0.0;
//const float freq = 0.75;
const float amp = 0.05;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 centeredUV = (UV - vec2(0.5, 0.5)) * 2.0;
	float v = mix(-1.5, 1.0, t);
	v = v + sin(TIME * (PI * 2.0) * (t*2.0)) * amp;
	float dist = length(centeredUV) + v;
	COLOR.a = dist;
	COLOR.r = max(0.0, 1.0-dist*2.0)/2.0;
	
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
