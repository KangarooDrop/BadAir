extends StaticBody3D

@export var target : String = ""
@export var speed : float = 1.0

var grabOffset : float = 0.2
var lastVelocity : Vector3 = Vector3.ZERO
var touching : Array = []

func _ready() -> void:
	initMoveArea()
	var mover = Util.trackMover.instantiate()
	add_child(mover)

func initMoveArea() -> void:
	var col : CollisionShape3D = Util.findByType(self, CollisionShape3D)
	if col != null:
		var area : Area3D = Area3D.new()
		var newCol : CollisionShape3D = col.duplicate()
		area.set_collision_layer_value(1, false)
		area.set_collision_mask_value(1, false)
		area.set_collision_mask_value(2, true)
		area.add_child(newCol)
		add_child(area)
		area.position.y = grabOffset
		area.body_entered.connect(self.onBodyEnter)
		area.body_exited.connect(self.onBodyExit)

func onBodyEnter(body) -> void:
	touching.append(body)

func onBodyExit(body) -> void:
	touching.erase(body)
	addLastVelocity(body)
	print("body left me")

func addLastVelocity(body) -> void:
	if "velocity" in body:
		body.velocity += lastVelocity
