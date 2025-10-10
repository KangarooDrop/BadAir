extends Node

const GROUP_TARGET : String = "Target"
const GROUP_PICKUP : String = "Pickup"

const ITEM_NONE : int = 0
const ITEM_BIRD : int = 1
const ITEM_LIGHTER : int = 2
const ITEM_MUSHROOM : int = 3

const trackMover : PackedScene = preload("res://scenes/TrackMover.tscn")

func initTarget(object : Node) -> void:
	var target : String = object.target
	await get_tree().process_frame
	object.targetEntity = findTaret(target)

func findTaret(targetname : String) -> Node:
	if targetname.is_empty():
		return null
	var targets : Array = get_tree().get_nodes_in_group(GROUP_TARGET)
	for targ in targets:
		if targ.targetname == targetname:
			return targ
	print("Could not find target: ", targetname)
	return null

func findByType(parent : Node, type) -> Node:
	for c in parent.get_children():
		if is_instance_of(c, type):
			return c
	return null

func getWorld() -> World:
	return get_tree().root.get_node("World")
