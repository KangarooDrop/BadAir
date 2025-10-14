extends Node

class_name AudioManager

#Gigachade Based Sigma Moment
var baseSigma : float = 0.125

var streamPlayers : Array = []

func _ready() -> void:
	Settings.settingsChange.connect(self.onSettingsChange)

func onSettingsChange(settingsKey : String) -> void:
	if settingsKey == Settings.volumeKey:
		updateStreamPlayers()

func updateStreamPlayers():
	var adjustedDB : float = getAudjustedDB()
	for asp in streamPlayers:
		asp.volume_db = adjustedDB

func getAudjustedDB(mult : float = 1.0) -> float:
	return linear_to_db(Settings.settingsVals[Settings.volumeKey] * mult)

func createAudioStreamPlayer(audioStream : AudioStream, pitch : float = 1.0, sigma : float = 0.0) -> AudioStreamPlayer:
	var asp = AudioStreamPlayer.new()
	asp.finished.connect(self.onPlayerFinished.bind(asp))
	asp.stream = audioStream
	asp.volume_db = getAudjustedDB()
	
	sigma += baseSigma
	asp.pitch_scale = pitch + randf_range(-sigma, sigma)
	
	add_child(asp)
	asp.play()
	
	streamPlayers.append(asp)
	
	return asp

func createAudioStreamPlayerAtPoint(audioStream : AudioStream, globalPos : Vector3, volumeMul : float = 1.0, pitch : float = 1.0, sigma : float = 0.0) -> AudioStreamPlayer3D:
	var asp = AudioStreamPlayer3D.new()
	asp.finished.connect(self.onPlayerFinished.bind(asp))
	asp.stream = audioStream
	asp.volume_db = getAudjustedDB(volumeMul)
	
	sigma += baseSigma
	asp.pitch_scale = pitch + randf_range(-sigma, sigma)
	
	add_child(asp)
	asp.global_position = globalPos
	asp.play()
	
	streamPlayers.append(asp)
	
	return asp

func onPlayerFinished(asp) -> void:
	clearStreamPlayer(asp)

func clearStreamPlayer(asp):
	streamPlayers.erase(asp)
	asp.queue_free()

func clearAll():
	for i in range(streamPlayers.size()-1, -1, -1):
		streamPlayers[i].queue_free()
	streamPlayers.clear()
