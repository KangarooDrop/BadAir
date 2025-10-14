extends Node

@export var text : String = ""

@onready var label : Label3D = $Label3D

func _ready() -> void:
	text = text.replace('\\n', '\n')
	print(text)
	label.text = text
