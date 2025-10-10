extends Node

@export var target : String = ""
@export var speed : float = 1.0
@export var radius : float = 3.0

@onready var particles : GPUParticles3D = $GPUParticles3D
@onready var col : CollisionShape3D = $Area3D/CollisionShape3D

static func getPartsPerUnit(testRadius : float) -> int:
	return int(64 * testRadius)

func _ready() -> void:
	(particles.process_material as ParticleProcessMaterial).emission_sphere_radius = radius
	particles.amount = getPartsPerUnit(radius)
	(col.shape as SphereShape3D).radius = radius

var touching : Array = []
func onBodyEnter(body: Node3D) -> void:
	if "canExplode" in body:
		touching.append(body)

func _process(delta: float) -> void:
	for body in touching:
		if body.canExplode:
			explode()
			body.onExplode()

func explode() -> void:
	pass

func onBodyExit(body: Node3D) -> void:
	touching.erase(body)
