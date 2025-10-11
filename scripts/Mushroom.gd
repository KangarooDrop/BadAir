extends Node

const MAX_TIME : float = 10.0

var itemID : int = Util.ITEM_MUSHROOM

func _ready() -> void:
	add_to_group(Util.GROUP_PICKUP)
