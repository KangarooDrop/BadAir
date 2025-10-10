extends Area3D

#Used for generic World level triggers
@export var target : String = ""
@export var targetname : String = ""
@export var single_use : bool = false

var targetEntity = null
var used : bool = false

func _ready() -> void:
	body_entered.connect(self.onBodyEnter)
	body_exited.connect(self.onBodyExit)
	add_to_group(Util.GROUP_TARGET)
	Util.initTarget(self)

func onBodyEnter(body):
	if single_use and used:
		return
	if is_instance_valid(targetEntity):
		targetEntity.onTriggerEnter(body, self)
		used = true

func onBodyExit(body):
	if is_instance_valid(targetEntity):
		targetEntity.onTriggerExit(body, self)
