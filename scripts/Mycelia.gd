extends Node3D

const SPAWN_MAX_TIME : float = 2.0

var mushroomItem : Item = null
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
	mushroomItem = Util.itemMushroom.duplicate()
	mushroomItem.on_death.connect(self.onRatDeath)
	Util.getWorld().getLevel().createMushroom(global_position + Vector3.UP*0.5, mushroomItem)
