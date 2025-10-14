extends AudioManager

const SIGMA_BASE : float = 0.05

const birdSafe : AudioStream = preload("res://audio/sound/birdSafe.ogg")
const birdLow : AudioStream = preload("res://audio/sound/birdLow.ogg")
const birdMed : AudioStream = preload("res://audio/sound/birdMed.ogg")
const birdHigh : AudioStream = preload("res://audio/sound/birdHigh.ogg")
const birdSounds : Array = [birdSafe, birdLow, birdMed, birdHigh]

const explosionSound : AudioStream = preload("res://audio/sound/explosion.ogg")
const earRingingSound : AudioStream = preload("res://audio/sound/ear_ringing.ogg")

const buttonSound0 : AudioStream = preload("res://audio/sound/button0.ogg")
const buttonSound1 : AudioStream = preload("res://audio/sound/button1.ogg")
const buttonSound2 : AudioStream = preload("res://audio/sound/button2.ogg")
const buttonSound3 : AudioStream = preload("res://audio/sound/button3.ogg")
const buttonSounds : Array = [buttonSound0, buttonSound1, buttonSound2, buttonSound3]

const impactSound : AudioStream = preload("res://audio/sound/impact.mp3")

func playBirdSound(index : int) -> AudioStreamPlayer:
	if index < 0 or index >= birdSounds.size():
		index = 0
	var stream : AudioStream = birdSounds[index]
	return createAudioStreamPlayer(stream)

func playExplosion() -> AudioStreamPlayer:
	return createAudioStreamPlayer(explosionSound)

func playEarRinging() -> AudioStreamPlayer:
	return createAudioStreamPlayer(earRingingSound)
	
func playImpact() -> AudioStreamPlayer: 
	return createAudioStreamPlayer(impactSound)

func playButtonPressed() -> AudioStreamPlayer:
	var stream : AudioStream = buttonSounds[randi() % buttonSounds.size()]
	return createAudioStreamPlayer(stream)

func playButtonHover() -> AudioStreamPlayer:
	var asp : AudioStreamPlayer = playButtonPressed()
	asp.volume_db = getAudjustedDB(0.5)
	return asp
