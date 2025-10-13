extends OmniLight3D

@onready var baseRange : float = self.omni_range

func getRangeCurve(val : float) -> float:
	return lerp(0.5, 1.5, val)

func _ready() -> void:
	Settings.settingsChange.connect(self.onSettingsChange)
	onSettingsChange(Settings.brightnessKey)

func onSettingsChange(settingsKey : String) -> void:
	if settingsKey == Settings.brightnessKey:
		omni_range = baseRange * getRangeCurve(Settings.settingsVals[Settings.brightnessKey])
