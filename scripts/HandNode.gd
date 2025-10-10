extends Node3D
class_name HandNode

func flipHandFunc() -> void:
	position.x = -position.x
	anim.flip_h = not anim.flip_h
	anim.offset.x = -anim.offset.x
	light.position.x = -light.position.x

signal on_swap_end()
signal on_throw_end()
signal on_grab_end()

var holding : int = Util.ITEM_NONE

var swapping : bool = false
var changedAnim : bool = false
var swapTimer : float = 0.0
const SWAP_MAX_TIME : float = 1.0
const SWAP_OFFSET : Vector2 = Vector2(0, -0.25)

var throwing : bool = false
var throwTimer : float = 0.0
var THROW_MAX_TIME : float = 0.5

var grabbing : bool = false
var grabTimer : float = 0.0
var GRAB_MAX_TIME : float = 0.5

@onready var anim : AnimatedSprite3D = $AnimatedSprite3D
@onready var light : OmniLight3D = $AnimatedSprite3D/LighterLight

func _ready() -> void:
	swapHolding(Util.ITEM_NONE)
	swapTimer = SWAP_MAX_TIME/2.0

func canChange() -> bool:
	return not swapping and not throwing and not grabbing

func swapHolding(newHolding : int) -> void:
	holding = newHolding
	swapping = true
	swapTimer = 0.0
	changedAnim = false

func throwHolding() -> void:
	throwing = true
	throwTimer = 0.0
	anim.play("throw")

func grabHolding() -> void:
	grabbing = true
	grabTimer = 0.0
	anim.play("grab")

static func getHoldingToAnim(itemHeld) -> String:
	match itemHeld:
		Util.ITEM_BIRD:
			return "idle_bird"
		Util.ITEM_LIGHTER:
			return "idle_lighter"
		Util.ITEM_MUSHROOM:
			return "idle_mushroom"
		_:
			return "idle_empty"

func _process(delta: float) -> void:
	if swapping:
		swapTimer += delta
		var t : float = swapTimer/SWAP_MAX_TIME
		var v : float = 1.0 - abs(2.0 * t - 1.0)
		anim.position.x = lerp(0.0, SWAP_OFFSET.x, v)
		anim.position.y = lerp(0.0, SWAP_OFFSET.y, v)
		if t > 0.5 and not changedAnim:
			anim.play(getHoldingToAnim(holding))
			changedAnim = true
		if t >= 1.0:
			anim.position.x = 0.0
			anim.position.y = 0.0
			swapping = false
			on_swap_end.emit()
	
	if throwing:
		throwTimer += delta
		if throwTimer >= THROW_MAX_TIME:
			throwing = false
			on_throw_end.emit()
			swapHolding(holding)
			swapTimer = SWAP_MAX_TIME
	
	if grabbing:
		grabTimer += delta
		if grabTimer >= GRAB_MAX_TIME:
			grabbing = false
			on_grab_end.emit()
			swapHolding(holding)
			swapTimer = SWAP_MAX_TIME
