extends CharacterBody3D
class_name Player

####################################################################################################

const SPEED : float = 5.0
const GRAV : float = 9.8
const JUMP_FORCE : float = 4.2

const CON_TRAC_GROUND : float = 0.5
const CON_TRAC_AIR : float = 0.125
const UNCON_TRAC_GROUND : float = 0.125
const UNCON_TRAC_AIR : float = 0.017

const SENSITIVITY : float = PI/300.0

####################################################################################################

var canControl : bool = true

####################################################################################################

@onready var head : Node3D = $Head
@onready var raycast : RayCast3D = $Head/RayCast3D
@onready var handLeft : HandNode = $Head/Camera3D/HandHolder/HandNodeLeft
@onready var handRight : HandNode = $Head/Camera3D/HandHolder/HandNodeRight

####################################################################################################

func _input(event: InputEvent) -> void:
	if not canControl:
		return
	
	if event is InputEventMouseMotion:
		var dp : Vector2 = -event.relative
		head.rotation.y += dp.x * SENSITIVITY
		head.rotation.x += dp.y * SENSITIVITY
		head.rotation.x = clampf(head.rotation.x, -PI/2.0, PI/2.0)

func _physics_process(delta: float) -> void:
	if canControl:
		#Grabbing
		if Input.is_action_just_pressed("mouse_left"):
			var col : Node = raycast.get_collider()
			if col != null and col.is_in_group(Util.GROUP_PICKUP):
				print("Found a pickup: ", col.name)
				pass
		
		#Jumping
		if is_on_floor():
			if Input.is_action_just_pressed("jump"):
				velocity.y = JUMP_FORCE
		
		#WASD Movement
		var inputDir : Vector2 = Input.get_vector("left", "right", "forward", "backward").rotated(-head.rotation.y)
		var moveDir : Vector3 = Vector3(inputDir.x, 0.0, inputDir.y).normalized()
		
		var tracLerpVal : float = 0.0
		if inputDir.is_zero_approx():
			if not is_on_floor():
				tracLerpVal = UNCON_TRAC_AIR
			else:
				tracLerpVal = UNCON_TRAC_GROUND
		else:
			if not is_on_floor():
				tracLerpVal = CON_TRAC_AIR
			else:
				tracLerpVal = CON_TRAC_GROUND
		
		velocity.x = lerp(velocity.x, moveDir.x * SPEED, tracLerpVal)
		velocity.z = lerp(velocity.z, moveDir.z * SPEED, tracLerpVal)
		
		if false:
			velocity.x = moveDir.x * SPEED
			velocity.z = moveDir.z * SPEED
	
	if not is_on_floor():
		velocity.y -= GRAV * delta
	move_and_slide()
