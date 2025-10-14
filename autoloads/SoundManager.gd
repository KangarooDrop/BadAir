extends AudioManager

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

const unlockSound : AudioStream = preload("res://audio/sound/unlock.ogg")

const lighterOpenSound : AudioStream = preload("res://audio/sound/lighterOpen.ogg")
const lighterStrikeSound : AudioStream = preload("res://audio/sound/lighterFlick.ogg")
const lighterSnuffSound : AudioStream = preload("res://audio/sound/lighterSnuff.ogg")
const lighterCloseSound : AudioStream = preload("res://audio/sound/lighterClose.ogg")

const ratSqueakSound0 : AudioStream = preload("res://audio/sound/ratSqueak0.ogg")
const ratSqueakSound1 : AudioStream = preload("res://audio/sound/ratSqueak1.ogg")
const ratSqueakSound2 : AudioStream = preload("res://audio/sound/ratSqueak2.ogg")
const ratSqueakSounds : Array = [ratSqueakSound0, ratSqueakSound1, ratSqueakSound2]
const ratDeathSound : AudioStream = preload("res://audio/sound/ratDeath.ogg")

const birdChirpSound0 : AudioStream = preload("res://audio/sound/birdChirp0.ogg")
const birdChirpSound1 : AudioStream = preload("res://audio/sound/birdChirp1.ogg")
const birdChirpSound2 : AudioStream = preload("res://audio/sound/birdChirp2.ogg")
const birdChirpSound3 : AudioStream = preload("res://audio/sound/birdChirp3.ogg")
const birdChirpSounds : Array = [birdChirpSound0, birdChirpSound1, birdChirpSound2, birdChirpSound3]

const mushroomPickupSound : AudioStream = preload("res://audio/sound/mushroomPickup.ogg")

const walkSound : AudioStream = preload("res://audio/sound/soundSquish.ogg")
const landingSound : AudioStream = preload("res://audio/sound/playerLanding.ogg")
const jumpSound : AudioStream = preload("res://audio/sound/playerJump.ogg")

const crunchSound0 : AudioStream = preload("res://audio/sound/crunch0.ogg")
const crunchSound1 : AudioStream = preload("res://audio/sound/crunch1.ogg")
const crunchSound2 : AudioStream = preload("res://audio/sound/crunch2.ogg")
const crunchSound3 : AudioStream = preload("res://audio/sound/crunch3.ogg")
const crunchSound4 : AudioStream = preload("res://audio/sound/crunch4.ogg")
const crunchSound5 : AudioStream = preload("res://audio/sound/crunch5.ogg")
const crunchSound6 : AudioStream = preload("res://audio/sound/crunch6.ogg")
const crunchSound7 : AudioStream = preload("res://audio/sound/crunch7.ogg")
const crunchSounds : Array = [crunchSound0, crunchSound1, crunchSound2, crunchSound3, crunchSound4, crunchSound5, crunchSound6, crunchSound7]

const bugWalkSound : AudioStream = preload("res://audio/sound/bugCrawl.ogg")
#preload("res://audio/sound/tapping.ogg")

const mushroomGrowSound : AudioStream = preload("res://audio/sound/soundSquish.ogg")

const wooshSound : AudioStream = preload("res://audio/sound/woosh.ogg")

func playStreamAtPoint(streamData, globalPos : Vector3) -> AudioStreamPlayer3D:
	var stream : AudioStream = streamData
	if typeof(streamData) == TYPE_STRING:
		stream = load(streamData)
	if stream == null:
		return null
	return createAudioStreamPlayerAtPoint(stream, globalPos)

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
	
func playUnlock() -> AudioStreamPlayer:
	return createAudioStreamPlayer(unlockSound)
	
func playLighterOpen() -> AudioStreamPlayer:
	return createAudioStreamPlayer(lighterOpenSound)
	
func playLighterStrike() -> AudioStreamPlayer:
	return createAudioStreamPlayer(lighterStrikeSound)
	
func playLighterSnuff() -> AudioStreamPlayer:
	return createAudioStreamPlayer(lighterSnuffSound)
	
func playLighterClose() -> AudioStreamPlayer:
	return createAudioStreamPlayer(lighterCloseSound)

func playRatSqueak(globalPos : Vector3, volumeMul : float = 1.0) -> AudioStreamPlayer3D:
	var audioStream : AudioStream = ratSqueakSounds[randi() % ratSqueakSounds.size()]
	return createAudioStreamPlayerAtPoint(audioStream, globalPos, volumeMul)

func playRatHand() -> AudioStreamPlayer:
	var audioStream : AudioStream = ratSqueakSounds[randi() % ratSqueakSounds.size()]
	return createAudioStreamPlayer(audioStream)

func playRatDeath(globalPos : Vector3) -> AudioStreamPlayer3D:
	return createAudioStreamPlayerAtPoint(ratDeathSound, globalPos)

func playBirdChirp(globalPos : Vector3) -> AudioStreamPlayer3D:
	var audioStream : AudioStream = birdChirpSounds[randi() % birdChirpSounds.size()]
	var asp : AudioStreamPlayer3D = createAudioStreamPlayerAtPoint(audioStream, globalPos)
	asp.volume_db = getAudjustedDB(0.25)
	return asp

func playMushroomPickup(globalPos : Vector3) -> AudioStreamPlayer3D:
	return createAudioStreamPlayerAtPoint(mushroomPickupSound, globalPos)

func playWalkSound() -> AudioStreamPlayer:
	var asp : AudioStreamPlayer = createAudioStreamPlayer(walkSound)
	asp.volume_db = getAudjustedDB(0.25)
	return asp

func playLandingSound(globalPos : Vector3, volumeMul) -> AudioStreamPlayer3D:
	var asp : AudioStreamPlayer3D = createAudioStreamPlayerAtPoint(landingSound, globalPos)
	asp.volume_db = getAudjustedDB(volumeMul)
	return asp

func playJump() -> AudioStreamPlayer:
	var asp : AudioStreamPlayer = createAudioStreamPlayer(jumpSound)
	return asp

func playCrunchSound(globalPos : Vector3) -> AudioStreamPlayer3D:
	var audioStream : AudioStream = crunchSounds[randi() % crunchSounds.size()]
	var asp : AudioStreamPlayer3D = createAudioStreamPlayerAtPoint(audioStream, globalPos)
	#asp.volume_db = getAudjustedDB(0.25)
	return asp

func playBugWalkSound(globalPos : Vector3) -> AudioStreamPlayer3D:
	return createAudioStreamPlayerAtPoint(bugWalkSound, globalPos, 1.0, 3.0)

func playMushroomGrow(globalPos : Vector3) -> AudioStreamPlayer3D:
	return createAudioStreamPlayerAtPoint(mushroomGrowSound, globalPos)

func playWoosh() -> AudioStreamPlayer:
	return createAudioStreamPlayer(wooshSound)
