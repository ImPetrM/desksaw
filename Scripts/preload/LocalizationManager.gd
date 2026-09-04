extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_init_language()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _init_language() -> void:
	TranslationServer.set_locale(gbData.settings.language)
	gbData.SettingsChanged.connect(_update_language)


func _update_language() -> void:
	TranslationServer.set_locale(gbData.settings.language)
