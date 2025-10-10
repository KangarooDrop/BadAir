@tool
extends Node3D
class_name HandNode

@export var flipHand : bool = false:
	set(val):
		if val:
			flipHandFunc()

func flipHandFunc() -> void:
	var anim : AnimatedSprite3D = $AnimatedSprite3D
	var light : Node3D = $AnimatedSprite3D/LighterLight
	position.x = -position.x
	anim.flip_h = not anim.flip_h
	anim.offset.x = -anim.offset.x
	light.position.x = -light.position.x
