extends Node3D
class_name HandNode

func flipHandFunc() -> void:
	position.x = -position.x
	anim.flip_h = not anim.flip_h
	anim.offset.x = -anim.offset.x
	light.position.x = -light.position.x

signal on_swap_end()
signal on_throw_end(thrownItem)
signal on_grab_end()
signal on_expire()

var heldItem : Item = null

var swapping : bool = false
var changedAnim : bool = false
var swapTimer : float = 0.0
const SWAP_MAX_TIME : float = 1.0
const SWAP_OFFSET : Vector2 = Vector2(0, -0.25)

var throwing : bool = false
var thrownItem : Item = null
var throwTimer : float = 0.0
const THROW_MAX_TIME : float = 0.5

var grabbing : bool = false
var grabTimer : float = 0.0
const GRAB_MAX_TIME : float = 0.5

@onready var anim : AnimatedSprite3D = $AnimatedSprite3D
@onready var light : OmniLight3D = $AnimatedSprite3D/LighterLight

func _ready() -> void:
	swapHolding(Util.itemEmpty)
	swapTimer = SWAP_MAX_TIME/2.0

func canChange() -> bool:
	return not swapping and not throwing and not grabbing

func onExpire() -> void:
	on_expire.emit()

func setLit(val : bool) -> void:
	light.visible = val
	if heldItem.id == Util.itemLighter.id:
		anim.play("idle_" + heldItem.animName + ("_lit" if val else ""))
	if heldItem.isLit and val:
		light.light_energy = heldItem.getLightEnergy()
		light.omni_range = heldItem.lightRange
		light.light_color = heldItem.lightColor

func setHeld(newItem : Item) -> void:
	if heldItem != null:
		heldItem.on_expire.disconnect(self.onExpire)
	
	heldItem = newItem
	
	newItem.on_expire.connect(self.onExpire)

func swapHolding(newItem : Item) -> void:
	setHeld(newItem)
	swapping = true
	swapTimer = 0.0
	changedAnim = false

func throwHolding() -> void:
	throwing = true
	throwTimer = 0.0
	anim.play("throw_" + heldItem.animName)
	thrownItem = heldItem

func grabHolding() -> void:
	grabbing = true
	grabTimer = 0.0
	anim.play("grab")

func _process(delta: float) -> void:
	if swapping:
		swapTimer += delta
		var t : float = swapTimer/SWAP_MAX_TIME
		var v : float = 1.0 - abs(2.0 * t - 1.0)
		anim.position.x = lerp(0.0, SWAP_OFFSET.x, v)
		anim.position.y = lerp(0.0, SWAP_OFFSET.y, v)
		if t > 0.5 and not changedAnim:
			anim.play("idle_" + heldItem.animName)
			changedAnim = true
			setLit(heldItem.isLit and not heldItem.id == Util.itemLighter.id)
		if t >= 1.0:
			anim.position.x = 0.0
			anim.position.y = 0.0
			swapping = false
			on_swap_end.emit()
	
	if throwing:
		throwTimer += delta
		if throwTimer >= THROW_MAX_TIME:
			throwing = false
			on_throw_end.emit(thrownItem)
			swapHolding(heldItem)
			swapTimer = SWAP_MAX_TIME/2.0
	
	if grabbing:
		grabTimer += delta
		if grabTimer >= GRAB_MAX_TIME:
			grabbing = false
			on_grab_end.emit()
			swapHolding(heldItem)
			swapTimer = SWAP_MAX_TIME
	
	if canChange():
		heldItem._process(delta)
		if heldItem.isLit and heldItem.lifetime != -1:
			light.light_energy = heldItem.getLightEnergy()

func onAnimFinished() -> void:
	if anim.animation == "squeeze_bird":
		anim.play("idle_bird")
	elif anim.animation == "squawk_bird":
		anim.play("idle_bird")
