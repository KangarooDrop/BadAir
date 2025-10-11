extends RigidBody3D
class_name ThrownItem

const MUSHROOM_TEX = preload("res://art/world/mushroom_picked.png")
const RAT_TEX = preload("res://art/world/rat.png")
const KEY_TEX = preload("res://art/world/key.png")
const FALLBACK_TEX = preload("res://art/hands/bird.png")

@onready var sprite : Sprite3D = $Sprite3D
@onready var light : OmniLight3D = $OmniLight3D

var itemID : int = Util.ITEM_NONE

func _ready() -> void:
	add_to_group(Util.GROUP_PICKUP)

func setItem(item : int) -> void:
	itemID = item
	light.visible = false
	match item:
		Util.ITEM_MUSHROOM:
			sprite.texture = MUSHROOM_TEX
			light.light_energy = Util.ENERGY_MUSHROOM
			light.omni_range = Util.RANGE_MUSHROOM
			light.light_color = Util.COLOR_MUSHROOM
			light.visible = true
		Util.ITEM_RAT:
			sprite.texture = RAT_TEX
		Util.ITEM_KEY:
			sprite.texture = KEY_TEX
		_:
			sprite.texture = FALLBACK_TEX
