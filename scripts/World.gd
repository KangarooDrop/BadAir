extends Node3D
class_name World

var player = null
var currentLevel = null

@onready var pauseScreen : CanvasLayer = $CanvasLayer

func _ready() -> void:
	pauseScreen.hide()
	Util.hideMouse()
	
	reset()

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

func onResumePressed() -> void:
	pauseScreen.hide()
	Util.hideMouse()
	player.canControl = true

func onSettingsPressed() -> void:
	Settings.show()

func onMainMenuPressed() -> void:
	get_tree().change_scene_to_file(Util.mainMenuScenePath)

####################################################################################################

func nextLevel() -> void:
	print("Level Complete!")
	Util.levelIndex += 1
	if Util.levelIndex < Util.levelPaths.size():
		reset()
	else:
		onMainMenuPressed()
		Credits.show()
		Util.levelIndex = 0

func reset() -> void:
	if is_instance_valid(currentLevel):
		currentLevel.queue_free()
	if is_instance_valid(player):
		if player.health <= 0.0:
			player.queue_free()
		else:
			player.onLevelEnd()
			player.velocity = Vector3.ZERO
			player.position.y = 999
	
	await get_tree().process_frame
	call_deferred("addPlayerAndLevel")

func addPlayerAndLevel():
	print("Loading Level #", Util.levelIndex)
	if not is_instance_valid(player):
		player = Util.playerScene.instantiate()
		add_child(player)
	
	currentLevel = load(Util.levelPaths[Util.levelIndex]).instantiate()
	add_child(currentLevel)

func getLevel():
	return currentLevel
