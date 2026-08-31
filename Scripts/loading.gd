extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/newmain.tscn")
	#TranslationServer.set_locale(gbData.settings.language)
	TranslationServer.set_locale("cs")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
