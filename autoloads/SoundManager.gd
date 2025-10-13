extends AudioManager

const SIGMA_BASE : float = 0.05

const birdSafe : AudioStream = preload("res://audio/sound/birdSafe.ogg")
const birdLow : AudioStream = preload("res://audio/sound/birdLow.ogg")
const birdMed : AudioStream = preload("res://audio/sound/birdMed.ogg")
const birdHigh : AudioStream = preload("res://audio/sound/birdHigh.ogg")
const birdSounds : Array = [birdSafe, birdLow, birdMed, birdHigh]

func playBirdSound(index : int) -> AudioStreamPlayer:
	if index < 0 or index >= birdSounds.size():
		index = 0
	var stream : AudioStream = birdSounds[index]
	return createAudioStreamPlayer(stream)
