shader_type canvas_item;

uniform vec2 size = vec2(160, 96);
uniform float offset = 16.0;
uniform float alpha = 0.0;

float stepifyFloat(float val, float stepper)
{
	return float(int(val / stepper)) * stepper;
}

void fragment() {
	vec2 newUV = UV;
	newUV.x = stepifyFloat(newUV.x, 1.0/size.x);
	newUV.x += sin(TIME + UV.y*4.0) * offset/size.x;

//	newUV.y = stepifyFloat(newUV.y, 1.0/size.y);
//	newUV.y += sin(-TIME * 4.141592/3.0) * offset/size.y;


	vec4 color = texture(TEXTURE, newUV);
	if(color.a != 0.0)
		color.a = alpha;
	COLOR = color;
}
