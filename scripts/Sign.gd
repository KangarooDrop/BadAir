extends Node

@export var text : String = ""

@onready var label : Label3D = $Label3D

func _ready() -> void:
	label.text = text
