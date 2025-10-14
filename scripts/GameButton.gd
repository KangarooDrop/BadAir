extends Button

func _ready() -> void:
	self.mouse_entered.connect(self.onMouseEnter)
	self.pressed.connect(self.onPress)

func onMouseEnter() -> void:
	SoundManager.playButtonHover()

func onPress() -> void:
	SoundManager.playButtonPressed()
