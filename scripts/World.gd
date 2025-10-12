extends Node3D
class_name World

@onready var player : Player = $Player
@onready var pauseScreen : CanvasLayer = $CanvasLayer

func _ready() -> void:
	pauseScreen.hide()
	Util.hideMouse()
	
	#Level code
	if not is_instance_valid(player):
		return
	var spawnPoints : Array = get_tree().get_nodes_in_group("PlayerSpawn")
	if spawnPoints.size() == 0:
		return
	var spawnNode : Node3D = spawnPoints[0]
	player.global_position = spawnNode.global_position
	player.head.rotation.y = spawnNode.rotation.y

func reset() -> void:
	get_tree().reload_current_scene()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		if Settings.visible:
			Settings.hide()
		elif Credits.visible:
			Credits.hide()
		else:
			if pauseScreen.visible:
				pauseScreen.hide()
				Util.hideMouse()
			else:
				pauseScreen.show()
				Util.showMouse()
			player.canControl = not pauseScreen.visible

#######################################
#TEMP CODE WHILE NO LEVEL SCENE IS LOADED#
func getLevel() -> Node3D:
	return self

func createRat(ratGlobalPos : Vector3, ratVel : Vector3, ratItem : Item = null) -> Object:
	var rat = Util.ratPacked.instantiate()
	rat.item = ratItem
	add_child(rat)
	rat.global_position = ratGlobalPos
	rat.velocity = ratVel
	return rat

func onTriggerEnter(body : Node3D, trigger : Trigger):
	print("Level wide trigger called for ", trigger.target)
	return true

func onTriggerExit(body : Node3D, trigger : Trigger) -> bool:
	return true


func onResumePressed() -> void:
	pauseScreen.hide()
	player.canControl = true

func onSettingsPressed() -> void:
	Settings.show()

func onMainMenuPressed() -> void:
	get_tree().change_scene_to_file(Util.mainMenuScenePath)
