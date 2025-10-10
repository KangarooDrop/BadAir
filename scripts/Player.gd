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

const KILL_PLANE : float = -300.0
const KILL_VEL : float = -20.0

####################################################################################################

func getGasStrengthToDec(gasStrength : int) -> float:
	match gasStrength:
		0:
			return HEALTH_MAX/30.0
		1:
			return HEALTH_MAX/10.0
		2:
			return HEALTH_MAX/3.0
	return 0.0

const HEALTH_MAX : float = 100.0
const HEALTH_TO_VISUAL : float = 20.0
const HEALTH_REGEN : float = HEALTH_MAX/3.0
var health : float = HEALTH_MAX
var canControl : bool = true
var canExplode : bool = false
var lastVelocity : Vector3 = Vector3.ZERO

####################################################################################################

@onready var head : Node3D = $Head
@onready var raycast : RayCast3D = $Head/RayCast3D
@onready var handLeft : HandNode = $Head/Camera3D/HandHolder/HandNodeLeft
@onready var handRight : HandNode = $Head/Camera3D/HandHolder/HandNodeRight
@onready var vignette : ColorRect = $Head/Camera3D/HUD/ScreenRect/Vignette

####################################################################################################

func _ready() -> void:
	handLeft.on_throw_end.connect(self.onHandThrowEnd.bind(handLeft))
	handRight.on_throw_end.connect(self.onHandThrowEnd.bind(handRight))

func onHandThrowEnd(handNode):
	pass

func _input(event: InputEvent) -> void:
	if not canControl:
		return
	
	if event is InputEventMouseMotion:
		var dp : Vector2 = -event.relative
		head.rotation.y += dp.x * SENSITIVITY
		head.rotation.x += dp.y * SENSITIVITY
		head.rotation.x = clampf(head.rotation.x, -PI/2.0, PI/2.0)
	
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		if event.keycode == KEY_1:
			handLeft.swapHolding(Util.ITEM_NONE)
		if event.keycode == KEY_2:
			handLeft.swapHolding(Util.ITEM_BIRD)
		if event.keycode == KEY_3:
			handLeft.swapHolding(Util.ITEM_LIGHTER)
		if event.keycode == KEY_4:
			handLeft.swapHolding(Util.ITEM_MUSHROOM)
	
			"""
	elif event is InputEventMouseButton and event.is_pressed():
		if event.button_index != MOUSE_BUTTON_LEFT and event.button_index != MOUSE_BUTTON_RIGHT:
			return
		var currentHand : HandNode = handLeft if event.button_index == MOUSE_BUTTON_LEFT else handRight
		if not currentHand.canChange():
			return
		var baseItem : int = Util.ITEM_LIGHTER if currentHand == handLeft else Util.ITEM_BIRD
		if currentHand.holding == Util.ITEM_NONE:
			var col : Node = raycast.get_collider()
			var pickupType : int = baseItem
			if col != null and col.is_in_group(Util.GROUP_PICKUP):
				pickupType = Util.ITEM_MUSHROOM
			if pickupType == baseItem:
				currentHand.swapHolding(baseItem)
			else:
				currentHand.holding = pickupType
				currentHand.grabHolding()
		elif currentHand.holding == baseItem:
			currentHand.swapHolding(Util.ITEM_NONE)
		else:
			currentHand.holding = Util.ITEM_NONE
			currentHand.throwHolding()
			"""

func _physics_process(delta: float) -> void:
	if canControl:
		#Grabbing
		if Input.is_action_just_pressed("mouse_left") or Input.is_action_just_pressed("mouse_right"):
			var currentHand : HandNode = handLeft if Input.is_action_just_pressed("mouse_left") else handRight
			if not currentHand.canChange():
				return
			var baseItem : int = Util.ITEM_LIGHTER if currentHand == handLeft else Util.ITEM_BIRD
			
			if currentHand.holding == Util.ITEM_NONE or currentHand.holding == baseItem:
				var col : Node = raycast.get_collider()
				var pickupType : int = Util.ITEM_NONE
				if col != null and col.is_in_group(Util.GROUP_PICKUP):
					pickupType = Util.ITEM_MUSHROOM
				if pickupType == Util.ITEM_NONE:
					if currentHand.holding == Util.ITEM_NONE:
						currentHand.grabHolding()
					elif baseItem == Util.ITEM_LIGHTER:
						currentHand.light.visible = not currentHand.light.visible
						canExplode = currentHand.light.visible
					else:
						print("SQUAK!")
				else:
					currentHand.swapHolding(pickupType)
			else:
				currentHand.throwHolding()
				currentHand.holding = baseItem
		
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
	lastVelocity = velocity
	move_and_slide()
	
	if velocity.y == 0.0 and lastVelocity.y < 0.0:
		if lastVelocity.y <= KILL_VEL:
			health = -999.0
	if position.y < KILL_PLANE:
		health = -999.0

####################################################################################################

func _process(delta: float) -> void:
	var vigVal : float = max(0.0, (HEALTH_TO_VISUAL-health)/HEALTH_TO_VISUAL)
	(vignette.material as ShaderMaterial).set_shader_parameter("t", vigVal)
	
	if health <= 0.0:
		canControl = false
		await get_tree().create_timer(1.0).timeout
		Util.getWorld().reset()
		return
	
	if poisonGasses.size() > 0:
		var strength : int = 0
		for pg in poisonGasses:
			strength = max(strength, pg.strength)
		health -= getGasStrengthToDec(strength) * delta
	elif health < HEALTH_MAX:
		health = min(health + HEALTH_REGEN * delta, HEALTH_MAX)

func onExplode() -> void:
	health = -999.0

var poisonGasses : Array = []
func onEnterPoison(poisonGas) -> void:
	poisonGasses.append(poisonGas)
func onExitPoison(poisonGas) -> void:
	poisonGasses.erase(poisonGas)
