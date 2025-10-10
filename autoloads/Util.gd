extends Node

const GROUP_TARGET : String = "Target"

func initTarget(object : Node) -> void:
	var target : String = object.target
	await get_tree().process_frame
	object.targetEntity = findTaret(target)

func findTaret(targetname : String) -> Node:
	var targets : Array = get_tree().get_nodes_in_group(GROUP_TARGET)
	for targ in targets:
		if targ.targetname == targetname:
			return targ
	return null
