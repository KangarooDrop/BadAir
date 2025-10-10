extends Node3D

@onready var parent : Node3D = get_parent()
var target : String = ""
var speed : float = 1.0

var targetEntity = null
var delay : float = 0.0
var lastVelocity : Vector3 = Vector3.ZERO

func _ready() -> void:
	target = parent.target
	speed = parent.speed
	Util.initTarget(self)

func _physics_process(delta: float) -> void:
	if not is_instance_valid(targetEntity):
		return
	
	if delay > 0.0:
		lastVelocity = Vector3.ZERO
		delay -= delta
		return
	
	var dp : Vector3 = targetEntity.global_position - global_position
	var mv : Vector3 = Vector3.ZERO
	if dp.length() > speed * delta:
		mv = dp.normalized() * speed
	else:
		mv = dp / delta
		delay = targetEntity.wait
		targetEntity = Util.findTaret(targetEntity.target)
	
	parent.global_position += mv * delta
	if "touching" in parent:
		for t in parent.touching:
			t.global_position += mv * delta
	
	lastVelocity = mv
	
