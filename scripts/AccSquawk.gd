extends Node

var popTimer : float = 0.0
const POP_MAX_TIME : float = 0.25
var fadeTimer : float = 0.0
const FADE_MAX_TIME : float = 0.75

const ROT_MAX : float = PI/4.0

@onready var scaler : Node2D = $Scaler
@onready var textureRect : TextureRect = $Scaler/TextureRect

func _ready() -> void:
	scaler.rotation = ROT_MAX * (randf()-0.5)*2.0

func _process(delta: float) -> void:
	if popTimer < POP_MAX_TIME:
		popTimer += delta
		var t : float = min(1.0, popTimer / POP_MAX_TIME)
		var f : float = t * (t - 1.0) * (t - 1.0) * 27.0/4.0
		scaler.scale = Vector2.ONE * lerp(1.0, 1.25, f)
		scaler.position.y = lerp(0.0, -2.0, f)
	elif fadeTimer < FADE_MAX_TIME:
		fadeTimer += delta
		var t : float = min(1.0, fadeTimer/FADE_MAX_TIME)
		scaler.modulate.a = 1.0 - t
	else:
		queue_free()
