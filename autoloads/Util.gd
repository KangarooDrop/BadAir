extends Node

const mouseModeHidden = Input.MOUSE_MODE_CAPTURED
const mouseModeShown = Input.MOUSE_MODE_VISIBLE

const mainMenuScenePath : String = "res://scenes/MainMenu.tscn"
const worldScenePath : String = "res://scenes/World.tscn"

const GROUP_TARGET : String = "Target"
const GROUP_PICKUP : String = "Pickup"
const GROUP_INTERACT : String = "Interact"

const thrownItem : PackedScene = preload("res://scenes/ThrownItem.tscn")
const trackMover : PackedScene = preload("res://scenes/TrackMover.tscn")
const ratPacked : PackedScene = preload("res://scenes/Rat.tscn")

var itemEmpty : Item = preload("res://scripts/items/ItemEmpty.tres")
var itemLighter : Item = preload("res://scripts/items/ItemLighter.tres")
var itemBird : Item = preload("res://scripts/items/ItemBird.tres")
var itemKey : Item = preload("res://scripts/items/ItemKey.tres")
var itemRat : Item = preload("res://scripts/items/ItemRat.tres")
var itemMushroom : Item = preload("res://scripts/items/ItemMushroom.tres")

func getGasStrengthToDec(gasStrength : int) -> float:
	match gasStrength:
		0:
			return 100.0/30.0
		1:
			return 100.0/10.0
		2:
			return 100.0/3.0
	return 0.0

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
	return get_tree().root.get_node_or_null("World")

func getCameraRotIndex(globalDir : Vector2) -> int:
	var players : Array = get_tree().get_nodes_in_group("Player")
	if players.size() == 0:
		return 0
	var player : Node3D = players[0]
	var camRot : float = 0.0 - player.head.rotation.y
	var gr : float = globalDir.angle()
	var diff : float = angle_difference(camRot, gr)
	return (int(fmod(diff + PI*2.0*2.0 - PI/4.0, PI*2.0) / (PI/2.0)))

func hideMouse() -> void:
	if Input.get_mouse_mode() != mouseModeHidden:
		Input.set_mouse_mode(mouseModeHidden)

func showMouse() -> void:
	if Input.get_mouse_mode() != mouseModeShown:
		Input.set_mouse_mode(mouseModeShown)
