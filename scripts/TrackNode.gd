extends Node3D

@export var targetname : String = ""
@export var target : String = ""
@export var wait : float = 0.0

func _ready() -> void:
	add_to_group(Util.GROUP_TARGET)
	$Sprite3D.hide()
