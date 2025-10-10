extends AnimatedSprite3D
class_name AnimatedSprite3DShader

func onFrameChanged() -> void:
	material_override.set_shader_parameter("tex", sprite_frames.get_frame_texture(animation, frame))
