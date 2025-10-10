extends Node

@export var target : String = ""
@export var speed : float = 1.0
@export var radius : float = 3.0
@export var strength : int = 0

@onready var col : CollisionShape3D = $Area3D/CollisionShape3D

func _ready() -> void:
	(col.shape as SphereShape3D).radius = radius

func onBodyEnter(body: Node3D) -> void:
	if body.has_method("onEnterPoison"):
		body.onEnterPoison(self)

func onBodyExit(body: Node3D) -> void:
	if body.has_method("onExitPoison"):
		body.onExitPoison(self)
