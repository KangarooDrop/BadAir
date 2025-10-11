extends Area3D
class_name Trigger

#Used for generic World level triggers
@export var target : String = ""
@export var targetname : String = ""
@export var single_use : bool = false

var targetEntity = null
var hasEntered : bool = false
var hasExited : bool = false

func _ready() -> void:
	body_entered.connect(self.onBodyEnter)
	body_exited.connect(self.onBodyExit)
	add_to_group(Util.GROUP_TARGET)
	Util.initTarget(self)

func onBodyEnter(body):
	if single_use and hasEntered:
		return
	if is_instance_valid(targetEntity):
		hasEntered = targetEntity.onTriggerEnter(body, self)
	elif target == "":
		hasEntered = Util.getWorld().getLevel().onTriggerEnter(body, self)
	else:
		printerr("Error: Trigger '", targetname, "' -> '", target, "' could not be found.")

func onBodyExit(body):
	if single_use and hasExited:
		return
	if is_instance_valid(targetEntity):
		hasExited = targetEntity.onTriggerExit(body, self)
	elif target == "":
		hasExited = Util.getWorld().getLevel().onTriggerEnter(body, self)
	else:
		printerr("Error: Trigger '", targetname, "' -> '", target, "' could not be found.")
