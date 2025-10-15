extends Level

@onready var soundHolder : Node3D = $SoundHolder
var motorPlayer : AudioStreamPlayer3D = null
var started : bool = false
var volumeTimer : float = 0.0
const VOLUME_MAX_TIME : float = 2.0

func _ready() -> void:
	super._ready()
	motorPlayer = SoundManager.playMotor(soundHolder.global_position)

func _exit_tree() -> void:
	motorPlayer.finished.emit()

func onBargeStart() -> void:
	started = true

func onTriggerEnter(body : Node3D, trigger : Trigger):
	if trigger.targetname == "onBargeStart":
		onBargeStart()
		return true
	else:
		return super.onTriggerEnter(body, trigger)

func _process(delta: float) -> void:
	if started:
		motorPlayer.global_position = soundHolder.global_position
		if volumeTimer < VOLUME_MAX_TIME:
			volumeTimer += delta
	var t : float = volumeTimer/VOLUME_MAX_TIME
	var v : float = -cos(3*PI*t)/(2*(t+1)) + 0.5 + 0.25*t
	motorPlayer.volume_db = SoundManager.getAudjustedDB(v * 0.5)
	#print(soundHolder.global_position)
