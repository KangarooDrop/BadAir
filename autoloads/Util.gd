extends Node

const GROUP_TARGET : String = "Target"
const GROUP_PICKUP : String = "Pickup"

const thrownItem : PackedScene = preload("res://scenes/ThrownItem.tscn")
const trackMover : PackedScene = preload("res://scenes/TrackMover.tscn")

var itemEmpty : Item = preload("res://scripts/items/ItemEmpty.tres")
var itemLighter : Item = preload("res://scripts/items/ItemLighter.tres")
var itemBird : Item = preload("res://scripts/items/ItemBird.tres")
var itemKey : Item = preload("res://scripts/items/ItemKey.tres")
var itemRat : Item = preload("res://scripts/items/ItemRat.tres")
var itemMushroom : Item = preload("res://scripts/items/ItemMushroom.tres")

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
