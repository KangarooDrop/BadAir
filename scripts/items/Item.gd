extends Resource
class_name Item

@export var id : int = -1
@export var animName : String = ""
@export var groundTexture : Texture = preload("res://art/hands/bird.png")
@export var canThrow : bool = false

@export var lifetime : float = -1.0

@export var isLit : bool = false
@export var lightEnergy : float = 1.0
@export var lightRange : float = 5.0
@export var lightColor : Color = Color.WHITE

signal on_expire()

func _process(delta : float) -> void:
	if lifetime != -1:
		lifetime -= delta
		if lifetime <= 0.0:
			on_expire.emit()
