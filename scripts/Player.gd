extends CharacterBody3D
class_name Player

@onready var head : Node3D = $Head

const SPEED : float = 5.0
const GRAV : float = 9.8
const JUMP_FORCE : float = 4.2

const SENSITIVITY : float = PI/300.0

var canControl : bool = true

func _input(event: InputEvent) -> void:
	if not canControl:
		return
	
	if event is InputEventMouseMotion:
		head.rotation.y += -event.relative.x * SENSITIVITY
		head.rotation.x += -event.relative.y * SENSITIVITY
		head.rotation.x = clampf(head.rotation.x, -PI/2.0, PI/2.0)

func _physics_process(delta: float) -> void:
	if canControl:
		if is_on_floor():
			if Input.is_action_just_pressed("jump"):
				velocity.y = JUMP_FORCE
		
		var inputDir : Vector2 = Input.get_vector("left", "right", "forward", "backward").rotated(-head.rotation.y)
		var moveDir : Vector3 = Vector3(inputDir.x, 0.0, inputDir.y).normalized()
		
		velocity.x = moveDir.x * SPEED
		velocity.z = moveDir.z * SPEED
	
	if not is_on_floor():
		velocity.y -= GRAV * delta
	move_and_slide()
