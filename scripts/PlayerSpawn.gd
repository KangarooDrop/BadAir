extends Node3D

@export var angle : int = 0

func _ready() -> void:
	print("Player Spawn: pos=", global_position, "; rot=", rotation.y)
