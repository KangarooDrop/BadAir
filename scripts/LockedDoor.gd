extends Node3D
class_name LockedDoor

@export var angle : int = 0

@onready var rotator : Node3D = $RotOffset
@onready var lock : Node3D = $RotOffset/Lock
@onready var lock2 : Node3D = $RotOffset/Lock2

const OPEN_MAX_TIME : float = 0.5
var openTimer : float = 0.0
var isOpen : bool = false
var opening : bool = false
var closing : bool = false

var touching : Array = []

func isLocked() -> bool:
	return lock.visible

func open() -> void:
	if not isLocked() and not closing and not isOpen:
		opening = true

func close() -> void:
	if not opening and isOpen:
		closing = true

func unlock() -> void:
	lock.visible = false
	lock2.visible = false
	SoundManager.playUnlock()
	open()

func _process(delta: float) -> void:
	if isLocked():
		for player in touching:
			if player.checkAndRemoveItem(Util.itemKey.id):
				unlock()
	
	if opening:
		openTimer = min(openTimer+delta, OPEN_MAX_TIME)
		var t : float = openTimer/OPEN_MAX_TIME
		rotator.rotation.y = lerp(0.0, PI/2.0, t)
		if t >= 1.0:
			opening = false
			isOpen = true
	elif closing:
		openTimer = max(openTimer-delta, 0.0)
		var t : float = openTimer/OPEN_MAX_TIME
		rotator.rotation.y = lerp(0.0, PI/2.0, t)
		if t <= 0.0:
			closing = false
			isOpen = false

func onBodyEnter(body : Node3D) -> void:
	if body is ThrownItem:
		if not isLocked():
			return
		if body.item.id != Util.itemKey.id:
			return
		body.queue_free()
		unlock()
	elif body is Player:
		touching.append(body)

func onBodyExit(body : Node3D) -> void:
	touching.erase(body)
