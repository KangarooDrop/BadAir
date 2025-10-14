extends Node

const mouseModeHidden = Input.MOUSE_MODE_CAPTURED
const mouseModeShown = Input.MOUSE_MODE_VISIBLE

const mainMenuScenePath : String = "res://scenes/MainMenu.tscn"
const worldScenePath : String = "res://scenes/World.tscn"

const GROUP_TARGET : String = "Target"
const GROUP_PICKUP : String = "Pickup"
const GROUP_INTERACT : String = "Interact"
const GROUP_RAT : String = "Rat"
const GROUP_BUGGIE : String = "Buggie"

var playerScene : PackedScene = load("res://scenes/Player.tscn")
var thrownItem : PackedScene = load("res://scenes/ThrownItem.tscn")
var trackMover : PackedScene = load("res://scenes/TrackMover.tscn")
var ratPacked : PackedScene = load("res://scenes/Rat.tscn")
var audioAccScene : PackedScene = load("res://scenes/AccSquawk.tscn")
var corpseScene : PackedScene = load("res://scenes/Corpse.tscn")
var mushroomScene : PackedScene = load("res://scenes/Mushroom.tscn")

var itemEmpty : Item = load("res://scripts/items/ItemEmpty.tres")
var itemBird : Item = load("res://scripts/items/ItemBird.tres")
var itemLighter : Item = load("res://scripts/items/ItemLighter.tres")
var itemMushroom : Item = load("res://scripts/items/ItemMushroom.tres")
var itemKey : Item = load("res://scripts/items/ItemKey.tres")
var itemRat : Item = load("res://scripts/items/ItemRat.tres")
var itemRock : Item = load("res://scripts/items/ItemRock.tres")

var levelIndex : int = 0
const levelPaths : Array = \
[

	"res://scenes/levels/LevelStart_TEST.tscn",
	"res://scenes/levels/LevelTunnelMaze.tscn",
	"res://scenes/levels/LevelBarge.tscn"
]

var envResource : Environment = load("res://scenes/Env.tres")
func _ready() -> void:
	Settings.settingsChange.connect(self.onSettingsChange)
	onSettingsChange(Settings.brightnessKey)
func onSettingsChange(settingsKey : String) -> void:
	pass
	#if settingsKey == Settings.brightnessKey:
	#	envResource.ambient_light_energy = lerp(0.0, 6.0, Settings.settingsVals[settingsKey])


func getGasStrengthToDec(gasStrength : int) -> float:
	match gasStrength:
		0:
			return 100.0/30.0
		1:
			return 100.0/10.0
		2:
			return 100.0/5.0
	return 0.0

func initTarget(object : Node) -> void:
	var target : String = object.target
	await get_tree().process_frame
	object.targetEntity = findTaret(target)
	object.targetSet = true

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

func findAllByType(parent : Node, type) -> Array:
	var rtn : Array = []
	for c in parent.get_children():
		if is_instance_of(c, type):
			rtn.append(c)
	return rtn

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
