extends CharacterBody3D
class_name Player

####################################################################################################

const SPEED : float = 4.0
const JUMP_FORCE : float = 4.2

const STEP_DIST : float = 32.0/64.0
const GROUND_DIST : float = 32.0/64.0
const CLIMB_VEL : float = 16.0/64.0 * 8.0

const CON_TRAC_GROUND : float = 0.5
const CON_TRAC_AIR : float = 0.125
const UNCON_TRAC_GROUND : float = 0.125
const UNCON_TRAC_AIR : float = 0.01

const SENS_MIN : float = PI * 0.5/480.0
const SENS_MAX : float = PI * 1.5/480.0

const KILL_VEL : float = -20.0

####################################################################################################

var grav : float = ProjectSettings.get_setting("physics/3d/default_gravity")

const HEALTH_MAX : float = 100.0
const BITE_MAX_TIME : float = 0.25
var biteTimer : float = 0.0
const TIME_TO_DEATH : float = 2.0
const HEALTH_TO_VISUAL : float = 20.0
const HEALTH_REGEN : float = HEALTH_MAX/3.0
var health : float = HEALTH_MAX
var canControl : bool = true
var dying : bool = false
var canExplode : bool = false
var lastVelocity : Vector3 = Vector3.ZERO
var handToThrowTime : Dictionary = {}

var climbingLastFrame : bool = false

const THROW_MAX_TIME : float = 0.5
const THROW_MAX_VEL : float = 15.0
const DROP_MAX_VEL : float = 5.0

var unlockedLighter : bool = Util.levelIndex > 0
var unlockedBird : bool = Util.levelIndex > 0

####################################################################################################

@onready var head : Node3D = $Head
@onready var raycast : RayCast3D = $Head/RayCast3D
@onready var handLeft : HandNode = $Head/Camera3D/HandHolder/HandNodeLeft
@onready var handRight : HandNode = $Head/Camera3D/HandHolder/HandNodeRight
@onready var vignette : ColorRect = $Head/Camera3D/HUD/ScreenRect/Vignette
@onready var crosshairIcon : TextureRect = $Head/Camera3D/HUD/ScreenRect/Center/Scaler/Icon
@onready var lighterPickupLabel : Label = $Head/Camera3D/HUD/ScreenRect/Center/Scaler/Label
@onready var birdPickupLabel : Label = $Head/Camera3D/HUD/ScreenRect/Center/Scaler/Label2

@onready var raycastGround : RayCast3D = $RayCastGround
@onready var raycastStep : RayCast3D = $RayCastStep

@onready var audioAccessHolder : Control = $Head/Camera3D/HUD/ScreenRect/AccessibilityHolder

####################################################################################################

func _ready() -> void:
	handLeft.on_throw_end.connect(self.onHandThrowEnd.bind(handLeft))
	handLeft.on_expire.connect(self.onHandExpire.bind(handLeft))
	handRight.on_throw_end.connect(self.onHandThrowEnd.bind(handRight))
	handRight.on_expire.connect(self.onHandExpire.bind(handRight))
	
	if unlockedLighter:
		handLeft.setHeld(Util.itemLighter)
	if unlockedBird:
		handRight.setHeld(Util.itemBird)
	
	audioAccessHolder.visible = Settings.settingsVals[Settings.audioAccessKey]
	Settings.settingsChange.connect(self.onSettingsChange)

func onLevelEnd() -> void:
	if not unlockedLighter:
		unlockedLighter = true
		if handLeft.heldItem.id == Util.itemEmpty.id:
			handLeft.swapHolding(Util.itemLighter)
	if not unlockedBird:
		unlockedBird = true
		if handRight.heldItem.id == Util.itemEmpty.id:
			handRight.swapHolding(Util.itemBird)

func onHandThrowEnd(item, handNode : HandNode):
	var throwVel : Vector3 = head.global_basis * Vector3.FORWARD * handToThrowTime[handNode]/THROW_MAX_TIME * THROW_MAX_VEL
	Util.getWorld().getLevel().createThrownItem(handNode.global_position, throwVel, item)
	handToThrowTime.erase(handNode)

func onHandExpire(handNode : HandNode) -> void:
	if handNode.heldItem.id == Util.itemMushroom.id:
		handNode.heldItem.on_death.emit()
		swapToBaseItem(handNode)
	elif handNode.heldItem.id == Util.itemRat.id:
		var dv2 : Vector2 = Vector2.UP.rotated(-head.rotation.y)
		var dropVel : Vector3 = Vector3(dv2.x, 1.0, dv2.y).normalized() * DROP_MAX_VEL
		Util.getWorld().getLevel().createRat(global_position, dropVel, handNode.heldItem)
		swapToBaseItem(handNode)
		handNode.swapTimer = HandNode.SWAP_MAX_TIME/2.0

func _input(event: InputEvent) -> void:
	if not canControl:
		return
	
	if event is InputEventMouseMotion:
		var dp : Vector2 = -event.relative
		var sensitivity : float = lerp(SENS_MIN, SENS_MAX, Settings.settingsVals[Settings.sensKey])
		head.rotation.y += dp.x * sensitivity
		head.rotation.x += dp.y * sensitivity
		head.rotation.x = clampf(head.rotation.x, -PI/2.0, PI/2.0)
	
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		if event.keycode == KEY_1:
			handLeft.swapHolding(Util.itemEmpty)
			canExplode = false
		if event.keycode == KEY_2:
			handLeft.swapHolding(Util.itemBird)
			canExplode = false
		if event.keycode == KEY_3:
			handLeft.swapHolding(Util.itemLighter)
			canExplode = false
		if event.keycode == KEY_4:
			handLeft.swapHolding(Util.itemMushroom.duplicate())
			canExplode = false
		if event.keycode == KEY_5:
			handLeft.swapHolding(Util.itemKey.duplicate())
			canExplode = false
		if event.keycode == KEY_6:
			handLeft.swapHolding(Util.itemRat.duplicate())
			canExplode = false
		if event.keycode == KEY_7:
			handLeft.swapHolding(Util.itemRock.duplicate())
			canExplode = false
	
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

func checkAndRemoveItem(itemID : int) -> bool:
	for hand in [handLeft, handRight]:
		if hand.heldItem.id == itemID:
			swapToBaseItem(hand)
			return true
	return false

func checkForItem(itemID : int) -> bool:
	for hand in [handLeft, handRight]:
		if hand.heldItem.id == itemID:
			return true
	return false

func getHandToBaseItem(hand : HandNode) -> Item:
	if hand == handLeft and unlockedLighter:
		return Util.itemLighter
	elif hand == handRight and unlockedBird:
		return Util.itemBird
	else:
		return Util.itemEmpty

func swapToBaseItem(hand : HandNode) -> void:
	var baseItem : Item = getHandToBaseItem(hand)
	hand.swapHolding(baseItem)

func setBaseItem(hand : HandNode) -> void:
	var baseItem : Item = getHandToBaseItem(hand)
	hand.setHeld(baseItem)
	
func checkPickupLabels() -> void:
	var iconIndex : int = 0
	var showLighterLabel : bool = false
	var showBirdLabel : bool = false
	var col : Node = raycast.get_collider()
	if col != null and col.is_in_group(Util.GROUP_PICKUP):
		if handLeft.heldItem.id == Util.itemEmpty.id or handRight.heldItem.id == Util.itemEmpty.id:
			if handLeft.heldItem.id == Util.itemEmpty.id and col.item.id == Util.itemLighter.id:
				showLighterLabel = true
			if handRight.heldItem.id == Util.itemEmpty.id and col.item.id == Util.itemBird.id:
				showBirdLabel = true
		iconIndex = 1
	
	(crosshairIcon.texture as AtlasTexture).region.position.x = iconIndex * 8.0
	lighterPickupLabel.visible = showLighterLabel
	birdPickupLabel.visible = showBirdLabel
	

func _physics_process(delta: float) -> void:
	checkPickupLabels()
	
	var tracLerpVal : float = UNCON_TRAC_GROUND if is_on_floor() else UNCON_TRAC_AIR
	var moveDir : Vector3 = Vector3.ZERO
	
	if canControl:
		#Grabbing
		if Input.is_action_just_pressed("mouse_left") or Input.is_action_just_pressed("mouse_right"):
			var currentHand : HandNode = handLeft if Input.is_action_just_pressed("mouse_left") else handRight
			if not currentHand.canChange():
				return
			var baseID : int = getHandToBaseItem(currentHand).id
			
			if currentHand.heldItem.id == Util.itemEmpty.id or currentHand.heldItem.id == baseID:
				var col : Node = raycast.get_collider()
				var pickup : Item = null
				if col != null and col.is_in_group(Util.GROUP_PICKUP):
					pickup = col.item
				if pickup == null:
					if currentHand.heldItem.id == Util.itemEmpty.id:
						currentHand.grabHolding()
						
					elif baseID == Util.itemLighter.id:
						currentHand.setLit(not currentHand.light.visible)
						canExplode = currentHand.light.visible
						if canExplode:
							SoundManager.playLighterStrike()
						else:
							SoundManager.playLighterSnuff()
					else:
						if not squawking:
							currentHand.anim.play("squeeze_bird")
							call_deferred("makeBirdCall")
				else:
					var canPickUp : bool = not((pickup == Util.itemLighter and currentHand == handRight) or \
											(pickup == Util.itemBird and currentHand == handLeft))
					if canPickUp:
						col.queue_free()
						currentHand.swapHolding(pickup)
						if pickup.id == Util.itemLighter.id:
							unlockedLighter = true
						elif pickup.id == Util.itemBird.id:
							unlockedBird = true
						if baseID == Util.itemLighter.id:
							canExplode = false
			else:
				handToThrowTime[currentHand] = 0.0
				currentHand.throwHolding()
				setBaseItem(currentHand)
		
		#Jumping
		if is_on_floor():
			if Input.is_action_just_pressed("jump"):
				velocity.y = JUMP_FORCE
		
		#WASD Movement
		var inputDir : Vector2 = Input.get_vector("left", "right", "forward", "backward")
		var iDirRot = inputDir.rotated(-head.rotation.y)
		moveDir = Vector3(iDirRot.x, 0.0, iDirRot.y).normalized()
		
		if not inputDir.is_zero_approx():
			tracLerpVal = CON_TRAC_GROUND if is_on_floor() else CON_TRAC_AIR
	
		var climbingThisFrame : bool = false
		if not inputDir.is_zero_approx():
			raycastGround.target_position = moveDir * GROUND_DIST
			raycastStep.target_position = moveDir * STEP_DIST
			if raycastGround.get_collider() && not raycastStep.get_collider():
				velocity.y = grav * delta + CLIMB_VEL
				climbingThisFrame = true
		if not climbingThisFrame and climbingLastFrame:
			velocity.y = 0.0
		climbingLastFrame = climbingThisFrame
	
	velocity.x = lerp(velocity.x, moveDir.x * SPEED, tracLerpVal)
	velocity.z = lerp(velocity.z, moveDir.z * SPEED, tracLerpVal)
	
	if not is_on_floor():
		velocity.y -= grav * delta
	lastVelocity = velocity
	move_and_slide()
	
	if velocity.y == 0.0 and lastVelocity.y < 0.0:
		if lastVelocity.y <= KILL_VEL:
			health = -999.0

####################################################################################################

func onSettingsChange(settingsKey : String) -> void:
	if settingsKey == Settings.audioAccessKey:
		audioAccessHolder.visible = Settings.settingsVals[Settings.audioAccessKey]

func _process(delta: float) -> void:
	if dying:
		position.y = 999.0
		canControl = false
		return
	
	if health <= 0.0:
		canControl = false
		dying = true
		vignette.material.set_shader_parameter("t", 1.0)
		
		await get_tree().create_timer(1.0).timeout
		Util.getWorld().reset()
		return
	
	var healthChange : float = 0.0
	if poisonGasses.size() > 0:
		var strength : int = 0
		for pg in poisonGasses:
			strength = max(strength, pg.strength)
		healthChange = -Util.getGasStrengthToDec(strength)
		#health -= Util.getGasStrengthToDec(strength) * delta
		
	elif health < HEALTH_MAX:
		healthChange = HEALTH_REGEN
		#health = min(health + HEALTH_REGEN * delta, HEALTH_MAX)
	
			
	if healthChange != 0.0:
		health = min(HEALTH_MAX, max(0.0, health + healthChange * delta))
	
	if biteTimer > 0.0:
		biteTimer -= delta
	
	vignette.material.set_shader_parameter("t", 0.0)
	if healthChange != 0.0:
		var timeLeft : float = TIME_TO_DEATH - (health + healthChange * TIME_TO_DEATH)/healthChange
		var timeVal : float = max(0.0, 1.0 - timeLeft/TIME_TO_DEATH)
		if timeVal > 1.0:
			timeVal = 0.0
		var bitVal : float = biteTimer/BITE_MAX_TIME * 0.25
		var hpVal : float = max(0.0, (HEALTH_TO_VISUAL-health)/HEALTH_TO_VISUAL)
		var v : float = max(bitVal, max(timeVal, hpVal))
		vignette.material.set_shader_parameter("t", v)
	
	if Input.is_action_pressed("mouse_left") and handToThrowTime.has(handLeft):
		handToThrowTime[handLeft] += delta
	if Input.is_action_pressed("mouse_right") and handToThrowTime.has(handRight):
		handToThrowTime[handRight] += delta
	if Input.is_action_just_released("mouse_left") and handToThrowTime.has(handLeft):
		handLeft.throwTimer = HandNode.THROW_MAX_TIME
	if Input.is_action_just_released("mouse_right") and handToThrowTime.has(handRight):
		handRight.throwTimer = HandNode.THROW_MAX_TIME

func onExplode() -> void:
	health = -999.0

var squawking : bool = false
var squawkBuffer : int = -1
func makeBirdCall(buffered : bool = false):
	if not checkForItem(Util.itemBird.id):
		return
	
	var squakStrength : int = currentPoisonStrength + 1
	if squawking:
		squawkBuffer = squakStrength
		return
	if squawkBuffer != -1:
		squakStrength = squawkBuffer
	
	squawking = true
	var asp = SoundManager.playBirdSound(squakStrength)
	asp.finished.connect(self.onSquawkFinished)
	
	for i in range(squakStrength):
		if audioAccessHolder.visible:
			var squakNode = Util.audioAccScene.instantiate()
			audioAccessHolder.add_child(squakNode)
		await get_tree().create_timer(0.15).timeout

func onSquawkFinished():
	squawking = false
	if squawkBuffer != -1:
		makeBirdCall()
		squawkBuffer = -1

var poisonGasses : Array = []
var currentPoisonStrength : int = -1
func onEnterPoison(poisonGas) -> void:
	poisonGasses.append(poisonGas)
	if poisonGas.strength > currentPoisonStrength:
		currentPoisonStrength = poisonGas.strength
		makeBirdCall(true)
		if handRight.heldItem.id == Util.itemBird.id:
			handRight.anim.play("squawk_bird")
		
func onExitPoison(poisonGas) -> void:
	poisonGasses.erase(poisonGas)
	var newPoisonStrength : int = -1
	for pg in poisonGasses:
		if pg.strength > newPoisonStrength:
			newPoisonStrength = pg.strength
	currentPoisonStrength = newPoisonStrength


func getBit(damage) -> bool:
	SoundManager.playImpact()
	health -= damage
	biteTimer = BITE_MAX_TIME
	return true
