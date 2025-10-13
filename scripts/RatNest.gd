extends Node3D

const RAT_VEL : float = 6.0
const SPAWN_MAX_TIME : float = 3.0

var ratItem : Item = null
var spawnTimer : float = 0.0

func _ready() -> void:
	setSpawnTimer()

func setSpawnTimer() -> void:
	spawnTimer = randf() * SPAWN_MAX_TIME

func _process(delta: float) -> void:
	if spawnTimer < SPAWN_MAX_TIME:
		spawnTimer += delta
		if spawnTimer >= SPAWN_MAX_TIME:
			createItem()

func onRatDeath() -> void:
	setSpawnTimer()

func createItem() -> void:
	ratItem = Util.itemRat.duplicate()
	ratItem.on_death.connect(self.onRatDeath)
	var v2 : Vector2 = Vector2.RIGHT.rotated(randf() * PI * 2.0)
	var vel : Vector3 = Vector3(v2.x, 1.0, v2.y).normalized() * RAT_VEL
	Util.getWorld().getLevel().createRat(global_position, vel, ratItem)
