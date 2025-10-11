extends Node3D

var item : Item = Util.itemLighter

func _ready() -> void:
	add_to_group(Util.GROUP_PICKUP)
