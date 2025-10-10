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

func _ready() -> void:
	add_to_group("TriggerHandler")

func onTriggerEnter(body, trigger) -> void:
	opening = true
	canClose = false

func onTriggerExit(body, trigger) -> void:
	canClose = true

func _physics_process(delta: float) -> void:
	#get_coll
	
	var mv : Vector3 = Vector3.ZERO
	if opening:
		var dp : Vector3 = (originalPosition + move_translation - global_position)
		if dp.length() > speed * delta:
			mv = dp.normalized() * speed
		else:
			mv = dp
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
