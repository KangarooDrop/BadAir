extends Resource
class_name Item

@export var id : int = -1
@export var animName : String = ""
@export var groundTexture : Texture = preload("res://art/hands/bird.png")
@export var canThrow : bool = false
@export var canDamage : bool = false

@export var lifetime : float = -1.0:
	set(val):
		lifetime = val
		currentLife = val

@export var isLit : bool = false
@export var lightEnergy : float = 1.0
@export var lightRange : float = 5.0
@export var lightColor : Color = Color.WHITE

var currentLife : float = -1.0

signal on_expire()
signal on_death()

func _process(delta : float) -> void:
	if lifetime != -1:
		currentLife -= delta
		if currentLife <= 0.0:
			on_expire.emit()

func getLightEnergy() -> float:
	return lightEnergy * sqrt(currentLife/lifetime)
