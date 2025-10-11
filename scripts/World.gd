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

#######################################
#TEMP CODE WHILE NO LEVEL SCENE IS LOADED#
func getLevel() -> Node3D:
	return self

func onTriggerEnter(body : Node3D, trigger : Trigger):
	print("Level wide trigger called for ", trigger.target)
	return true

func onTriggerExit(body : Node3D, trigger : Trigger) -> bool:
	return true
