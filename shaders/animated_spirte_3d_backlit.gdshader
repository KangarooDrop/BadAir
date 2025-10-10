shader_type spatial;
render_mode cull_disabled;

uniform sampler2D tex : source_color, filter_nearest;
uniform float scale = 1.5625; //100.0/64.0 scales 64px up to 1 unit

void vertex() {
    mat4 modified_model_view = VIEW_MATRIX * mat4(
        INV_VIEW_MATRIX[0] * scale,
        vec4(0.0, 1.0, 0.0, 0.0) * scale,
        INV_VIEW_MATRIX[2],
        MODEL_MATRIX[3] // / 1.5
    );
    MODELVIEW_MATRIX = modified_model_view;
}


/*
void vertex() {
	// Billboard Mode: Y-Billboard
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(
			vec4(normalize(cross(vec3(0.0, 1.0, 0.0), MAIN_CAM_INV_VIEW_MATRIX[2].xyz)), 0.0),
			vec4(0.0, 1.0, 0.0, 0.0),
			vec4(normalize(cross(MAIN_CAM_INV_VIEW_MATRIX[0].xyz, vec3(0.0, 1.0, 0.0))), 0.0),
			MODEL_MATRIX[3]);
	MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
}
*/

void fragment() {
    vec4 color = texture(tex, UV);
    ALBEDO = vec3(color.r, color.g, color.b);
	ALPHA = color.a;
	BACKLIGHT = vec3(1.0, 1.0, 1.0);
}