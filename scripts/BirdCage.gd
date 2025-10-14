extends Node3D
const CHIRP_MAX_TIME : float = 15.0
const CHIRP_MIN_TIME : float = 6.0

var item : Item = Util.itemBird
var chirpTimer : float = CHIRP_MIN_TIME

var chirpPlayer : AudioStreamPlayer3D = null

func _ready() -> void:
	add_to_group(Util.GROUP_PICKUP)

func _process(delta: float) -> void:
	chirpTimer -= delta
	if chirpTimer <= 0.0:
		chirpPlayer = SoundManager.playBirdChirp(global_position)
		chirpTimer = lerp(CHIRP_MIN_TIME, CHIRP_MAX_TIME, randf())

func _exit_tree() -> void:
	if chirpPlayer != null:
		chirpPlayer.finished.emit()

func onPickup():
	if Util.getWorld() != null:
		SoundManager.playBirdSound(0)
