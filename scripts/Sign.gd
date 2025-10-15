extends Node

@export var text : String = ""
@export var font_size : int = 32
@export var angle : float = 0

@onready var label : Label3D = $Label3D

func _ready() -> void:
	text = text.replace('\\n', '\n')
	label.text = text
	label.font_size = font_size
