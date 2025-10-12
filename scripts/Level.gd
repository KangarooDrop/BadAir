extends Node3D
class_name Level

@onready var map : FuncGodotMap = $FuncGodotMap

func _ready() -> void:
	var player = Util.getWorld().player
	var spawnPoints : Array = get_tree().get_nodes_in_group("PlayerSpawn")
	if spawnPoints.size() == 0:
		return
	var spawnNode : Node3D = spawnPoints[0]
	print("Player Spawn: pos=", spawnNode.global_position, "; rot=", spawnNode.rotation.y)
	player.global_position = spawnNode.global_position
	player.head.rotation.y = spawnNode.rotation.y

func createRat(ratGlobalPos : Vector3, ratVel : Vector3, ratItem : Item = null) -> Object:
	var rat = Util.ratPacked.instantiate()
	rat.item = ratItem
	map.add_child(rat)
	rat.global_position = ratGlobalPos
	rat.velocity = ratVel
	return rat

func createThrownItem(tiGlobalPos : Vector3, throwVel : Vector3, item : Item):
	var thrownItem : ThrownItem = Util.thrownItem.instantiate()
	map.add_child(thrownItem)
	thrownItem.global_position = tiGlobalPos
	thrownItem.setItem(item)
	thrownItem.linear_velocity = throwVel

func onTriggerEnter(_body : Node3D, trigger : Trigger):
	if trigger.targetname == "LevelEnd":
		if Util.levelIndex == 1:
			pass
		Util.getWorld().nextLevel()
	return true

func onTriggerExit(_body : Node3D, _trigger : Trigger) -> bool:
	return true
