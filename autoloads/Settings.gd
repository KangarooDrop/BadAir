extends CanvasLayer

const defaultSettings : Dictionary = \
{
	brightnessKey : 0.5,
	sensKey : 0.5,
	volumeKey : 0.5,
	audioAccessKey : false,
}

const brightnessKey : String = "brightness"
const sensKey : String = "mouse_sens"
const volumeKey : String = "volume"
const audioAccessKey : String = "audio_access"

var settingsVals : Dictionary = defaultSettings.duplicate()

@onready var brightnessLabel : Label = $ColorRect/ButtonHolder/HBoxContainer/LabelsVBox/BrightnessHolder/BrightnessLabel
@onready var sensLabel : Label = $ColorRect/ButtonHolder/HBoxContainer/LabelsVBox/SensHolder/SensLabel
@onready var volumeLabel : Label = $ColorRect/ButtonHolder/HBoxContainer/LabelsVBox/VolumeHolder/VolumeLabel
@onready var audioAccessLabel : Label = $ColorRect/ButtonHolder/HBoxContainer/LabelsVBox/AudioAccessHolder/AudioAccessLabel

@onready var brightnessSlider : HSlider = $ColorRect/ButtonHolder/HBoxContainer/OptionsVBox/BrightnessHolder/BrightnessSlider
@onready var sensSlider : HSlider = $ColorRect/ButtonHolder/HBoxContainer/OptionsVBox/SensHolder/SensSlider
@onready var volumeSlider : HSlider = $ColorRect/ButtonHolder/HBoxContainer/OptionsVBox/VolumeHolder/VolumeSlider
@onready var audioAccessButton : CheckButton = $ColorRect/ButtonHolder/HBoxContainer/OptionsVBox/AudioAccessHolder/AudioAccessButton

signal settingsChange(settingsKey : String)

func _ready() -> void:
	brightnessSlider.value = settingsVals[brightnessKey]
	onBrightnessChange(brightnessSlider.value)
	
	sensSlider.value = settingsVals[sensKey]
	onSensChange(sensSlider.value)
	
	volumeSlider.value = settingsVals[volumeKey]
	onVolumeChange(volumeSlider.value)
	
	audioAccessButton.button_pressed = settingsVals[audioAccessKey]
	onAudioAccessChange(audioAccessButton.button_pressed)
	
	hide()

func onBrightnessChange(val : float) -> void:
	settingsVals[brightnessKey] = val
	brightnessLabel.text = "Brightness: " + str(int(100.0 * val)) + "%"
	settingsChange.emit(brightnessKey)

func onSensChange(val : float) -> void:
	settingsVals[sensKey] = val
	sensLabel.text = "Mouse Sensitivity: " + str(int(100.0 * val)) + "%"
	settingsChange.emit(sensKey)

func onVolumeChange(val : float) -> void:
	settingsVals[volumeKey] = val
	volumeLabel.text = "Volume: " + str(int(100.0 * val)) + "%"
	settingsChange.emit(volumeKey)

func onAudioAccessChange(val : bool) -> void:
	settingsVals[audioAccessKey] = val
	audioAccessLabel.text = "Audio Accessibility: " + ("On" if val else "Off")
	settingsChange.emit(audioAccessKey)

func onClosePressed() -> void:
	hide()
