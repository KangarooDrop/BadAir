extends Node3D
class_name Lantern

@export var is_lit : bool = true

@onready var anim : AnimatedSprite3D = $AnimatedSprite3dShader
@onready var light : OmniLight3D = $OmniLight3D

func _ready() -> void:
	if is_lit:
		anim.play("lit")
		light.visible = true
	else:
		anim.play("unlit")
		light.visible = false
