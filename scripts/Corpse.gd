extends Node3D

@onready var sprite : Sprite3D = $Sprite3D
@onready var shaderMat : ShaderMaterial = sprite.material_override as ShaderMaterial

func setTexture(texture : Texture) -> void:
	sprite.texture = texture
	shaderMat.set_shader_parameter("tex", texture)
