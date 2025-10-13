extends Node

class_name AudioManager

var streamPlayers : Array = []

func _ready() -> void:
	Settings.settingsChange.connect(self.onSettingsChange)

func onSettingsChange(settingsKey : String) -> void:
	if settingsKey == Settings.volumeKey:
		updateStreamPlayers()

func updateStreamPlayers():
	var adjustedDB : float = getAudjustedDB()
	for asp : AudioStreamPlayer in streamPlayers:
		asp.volume_db = adjustedDB

func getAudjustedDB() -> float:
	return linear_to_db(Settings.settingsVals[Settings.volumeKey])

func createAudioStreamPlayer(audioStream : AudioStream, pitch : float = 1.0, sigma : float = 0.0) -> AudioStreamPlayer:
	var asp : AudioStreamPlayer = AudioStreamPlayer.new()
	asp.finished.connect(self.onPlayerFinished.bind(asp))
	asp.stream = audioStream
	asp.volume_db = getAudjustedDB()
	
	asp.pitch_scale = pitch + randf_range(-sigma, sigma)
	
	add_child(asp)
	asp.play()
	
	streamPlayers.append(asp)
	
	return asp

func onPlayerFinished(asp : AudioStreamPlayer) -> void:
	clearStreamPlayer(asp)

func clearStreamPlayer(asp : AudioStreamPlayer):
	streamPlayers.erase(asp)
	asp.queue_free()

func clearAll():
	for i in range(streamPlayers.size()-1, -1, -1):
		streamPlayers[i].queue_free()
	streamPlayers.clear()
