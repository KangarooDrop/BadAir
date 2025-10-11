extends Node

const MAX_TIME : float = 10.0

var item : Item = Util.itemMushroom.duplicate()

func _ready() -> void:
	add_to_group(Util.GROUP_PICKUP)
