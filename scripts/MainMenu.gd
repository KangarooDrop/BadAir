extends Node3D

const CAM_HEIGHT : float = 3.9
const CAM_OFFSET : float = -0.5
const CAM_ROT_X : float = -PI * 1.0/4.0
const CAM_ROT_Y : float = PI
const CAM_TURN_PERIOD : float = 30.0

const TITLE_MAX_TIME : float = 2.5
const TITLE_MAX_ALPHA : float = 0.8

var hasPanned : bool = false

var camTimer : float = 0.0
var titleTimer : float = 0.0

@onready var rotator : Node3D = $CamRot
@onready var cam : Camera3D = $CamRot/Camera3D

@onready var playButton : Button = $CanvasLayer/ScreenBounds/ButtonHolder/VBoxContainer/PlayButton
@onready var continueButton : Button = $CanvasLayer/ScreenBounds/ButtonHolder/VBoxContainer/ContinueButton
@onready var newButton : Button = $CanvasLayer/ScreenBounds/ButtonHolder/VBoxContainer/NewButton
@onready var titleRect : TextureRect = $CanvasLayer/ScreenBounds/TitleHolder/Scaler/TextureRect

func _ready() -> void:
	cam.position.y = CAM_HEIGHT
	cam.position.z = CAM_OFFSET
	
	cam.rotation.x = CAM_ROT_X
	cam.rotation.y = CAM_ROT_Y
	
	Util.showMouse()
	MusicManager.playMainMenu()
	
	playButton.visible = (Util.levelIndex == 0)
	continueButton.visible = not playButton.visible
	newButton.visible = continueButton.visible

func _process(delta: float) -> void:
	camTimer += delta
	if camTimer >= CAM_TURN_PERIOD:
		camTimer -= CAM_TURN_PERIOD
		hasPanned = true
	
	var t: float = camTimer / CAM_TURN_PERIOD
	if not hasPanned:
		var easeVal : float = -(cos(PI * t) - 1) / 2;
		cam.rotation.x = lerp(-PI*3.0/8.0, CAM_ROT_X, easeVal)
	
	var newRotation : float = t * 2.0 * PI
	rotator.rotation.y = newRotation
	#cam.position.z = sin(camTimer / 3.0 * 2.0 * PI) * CAM_OFFSET
	
	if titleTimer < TITLE_MAX_TIME:
		titleTimer = min(TITLE_MAX_TIME, titleTimer + delta)
		titleRect.material.set_shader_parameter("alpha", TITLE_MAX_ALPHA * titleTimer/TITLE_MAX_TIME)
	
	if Input.is_action_just_pressed("escape"):
		if Settings.visible:
			Settings.hide()
		elif Credits.visible:
			Credits.hide()

func onPlayPressed() -> void:
	#if Util.levelIndex == 0:
	#	SoundManager.playExplosion()
	#	SoundManager.playEarRinging()
	get_tree().change_scene_to_file(Util.worldScenePath)

func onNewPressed() -> void:
	Util.levelIndex = 0
	onPlayPressed()

func onContinuePressed() -> void:
	onPlayPressed()

func onSettingsPressed() -> void:
	Settings.show()

func onCreditsPressed() -> void:
	Credits.show()

func onQuitPressed() -> void:
	get_tree().quit()
