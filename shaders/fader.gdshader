shader_type canvas_item;

uniform vec2 texSize = vec2(640.0, 480.0);
uniform float pixSize = 16.0;
uniform int posterization = 8;
uniform vec2 offset = vec2(0.0, 0.0);

float stepifyFloat(float val, float stepper)
{
	return float(int(val / stepper)) * stepper;
}

void fragment() {
	//Snapping UV to 16x16 grid
	vec2 uv = UV;
	//uv.x = stepifyFloat(UV.x, pixSize/texSize.x);
	//uv.y = stepifyFloat(UV.y, pixSize/texSize.y);
	
	//Getting distance from center
	vec2 centeredUV = (uv - vec2(0.5, 0.5)) * 2.0 + offset/texSize*2.0;
	float dist = length(centeredUV);
	
	//Curving dist value
	float v = abs(abs(centeredUV.x)-abs(centeredUV.y)) * dist;
	v /= 2.0;
	float texAlpha = mix(COLOR.a, 0.0, v);
	
	//Reducing output texture alpha to [0.0, 1.0/p, 2.0/p, ..., 1.0]
	float invP = 1.0/float(posterization+1);
	//texAlpha = stepifyFloat(texAlpha + invP, invP);
	texAlpha = min(1.0, max(0.0, texAlpha));
	COLOR.a = texAlpha;
}