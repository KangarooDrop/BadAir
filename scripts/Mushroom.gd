extends Node

const MAX_TIME : float = 10.0

var item : Item = Util.itemMushroom.duplicate()

const GROW_MAX_TIME : float = 1.0
const GROW_OFFSET : float = -0.75
var growTimer : float = 0.0

@onready var anim : AnimatedSprite3D = $AnimatedSprite3dShader

func _ready() -> void:
	add_to_group(Util.GROUP_PICKUP)
	anim.position.y = GROW_OFFSET

func _process(delta: float) -> void:
	if growTimer < GROW_MAX_TIME:
		growTimer = min(1.0, growTimer+delta)
	anim.position.y = lerp(GROW_OFFSET, 0.0, growTimer)
