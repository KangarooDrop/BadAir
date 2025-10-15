extends AudioManager

const musicMainMenu : AudioStream = preload("res://audio/ambiance/InMotionAudio-EerieBoilerRoom.wav")
const musicInGame : AudioStream = preload("res://audio/ambiance/cave.ogg")
const musicFallback : AudioStream = musicMainMenu

enum MUSIC_GROUPS {MAIN_MENU, AMBIANCE}
var currentState : MUSIC_GROUPS = -1

const stateToMusicGroups : Dictionary = {
	-1 : [musicFallback],
	MUSIC_GROUPS.MAIN_MENU : [musicMainMenu],
	MUSIC_GROUPS.AMBIANCE : [musicInGame],
}

@onready var musicPlayer : AudioStreamPlayer = createAudioStreamPlayer(null)

func _ready() -> void:
	super._ready()
	baseSigma = 0.0
	updateStreamPlayers()

func updateStreamPlayers():
	var adjustedDB : float = getAudjustedDB(0.5)
	for asp in streamPlayers:
		asp.volume_db = adjustedDB

func playMusicStream(audioStream : AudioStream) -> void:
	if musicPlayer.stream == audioStream and musicPlayer.playing:
		return
	musicPlayer.stream = audioStream
	musicPlayer.play()

func refreshMusic():
	var musicGroup : Array = stateToMusicGroups[currentState]
	if musicGroup.is_empty():
		musicGroup = stateToMusicGroups[-1]
	var stream : AudioStream = musicGroup[randi() % musicGroup.size()]
	playMusicStream(stream)

func setState(newState):
	if newState == -1 or not stateToMusicGroups.has(newState) or currentState == newState:
		return
	currentState = newState
	refreshMusic()

func playMainMenu() -> void:
	setState(MUSIC_GROUPS.MAIN_MENU)

func playAmbiance() -> void:
	setState(MUSIC_GROUPS.AMBIANCE)

func onPlayerFinished(_asp : AudioStreamPlayer) -> void:
	refreshMusic()
