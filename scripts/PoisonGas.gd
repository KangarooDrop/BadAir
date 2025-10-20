extends Node3D

@export var target : String = ""
@export var speed : float = 1.0
@export var radius : float = 3.0
@export var strength : int = 0

@onready var col : CollisionShape3D = $Area3D/CollisionShape3D
@onready var debugMesh : MeshInstance3D = $MeshInstance3D

func _ready() -> void:
	(col.shape as SphereShape3D).radius = radius
	(debugMesh.mesh as SphereMesh).radius = radius
	(debugMesh.mesh as SphereMesh).height = radius*2.0

func onBodyEnter(body: Node3D) -> void:
	if "Player" in body.name and not Util.getWorld().hasReset:
		return
	if body.has_method("onEnterPoison"):
		body.onEnterPoison(self)

func onBodyExit(body: Node3D) -> void:
	if "Player" in body.name and not Util.getWorld().hasReset:
		return
	if Util.getWorld().hasReset and body.has_method("onExitPoison"):
		body.onExitPoison(self)
