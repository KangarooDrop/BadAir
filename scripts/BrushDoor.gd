extends StaticBody3D

@export var targetname : String = ""
@export var move_translation : Vector3 = Vector3.ZERO
@export var speed : float = 1.0
@export var stay_open : bool = true
@export var wait : float = 0.0

@onready var originalPosition : Vector3 = global_position
var opening : bool = false
var canClose : bool = true
var waitTimer : float = 0.0
var closing : bool = false

var grabOffset : float = 0.2
var lastVelocity : Vector3 = Vector3.ZERO
var touching : Array = []

func _ready() -> void:
	add_to_group(Util.GROUP_TARGET)
	initMoveArea()

func initMoveArea() -> void:
	var col : CollisionShape3D = Util.findByType(self, CollisionShape3D)
	if col != null:
		var area : Area3D = Area3D.new()
		var newCol : CollisionShape3D = col.duplicate()
		area.set_collision_layer_value(1, false)
		area.set_collision_mask_value(1, false)
		area.set_collision_mask_value(2, true)
		area.set_collision_mask_value(3, true)
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

func addLastVelocity(body) -> void:
	if "velocity" in body:
		body.velocity += lastVelocity

func onTriggerEnter(body : Node3D, trigger : Trigger) -> bool:
	opening = true
	canClose = false
	return true

func onTriggerExit(body : Node3D, trigger : Trigger) -> bool:
	canClose = true
	return true

func _physics_process(delta: float) -> void:
	var mv : Vector3 = Vector3.ZERO
	if opening:
		var dp : Vector3 = (originalPosition + move_translation - global_position)
		if dp.length() > speed * delta:
			mv = dp.normalized() * speed
		else:
			mv = dp / delta
			opening = false
			if not stay_open:
				closing = true
				waitTimer = wait
	elif waitTimer > 0:
		waitTimer -= delta
	elif closing and canClose:
		var dp : Vector3 = (originalPosition - global_position)
		if dp.length() > speed * delta:
			mv = dp.normalized() * speed
		else:
			mv = dp
			closing = false
	
	move_and_collide(mv * delta)
	for t in touching:
		t.global_position += mv * delta
	
	lastVelocity = mv
