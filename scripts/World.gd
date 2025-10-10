extends Node3D
class_name World

@onready var player : Player = $Player

func _ready() -> void:
	if not is_instance_valid(player):
		return
	var spawnPoints : Array = get_tree().get_nodes_in_group("PlayerSpawn")
	if spawnPoints.size() == 0:
		return
	var spawnNode : Node3D = spawnPoints[0]
	player.global_position = spawnNode.global_position

func reset() -> void:
	get_tree().reload_current_scene()
