extends Node

@export var target : String = ""
@export var speed : float = 1.0
@export var radius : float = 3.0

@onready var particles : GPUParticles3D = $GPUParticles3D
@onready var col : CollisionShape3D = $Area3D/CollisionShape3D

static func getPartsPerUnit(radius : float) -> int:
	return int(64 * radius)

func _ready() -> void:
	(particles.process_material as ParticleProcessMaterial).emission_sphere_radius = radius
	particles.amount = getPartsPerUnit(radius)
	(col.shape as SphereShape3D).radius = radius

func onBodyEnter(body: Node3D) -> void:
	print(body.name)

func onBodyExit(body: Node3D) -> void:
	pass
