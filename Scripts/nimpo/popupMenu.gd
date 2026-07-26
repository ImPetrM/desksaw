extends Control


@export
var clickthrough: Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_menu_pressed() -> void:
	GlobalVariable.consoleF(true)


func _on_pet_pressed() -> void:
	if gbData.data.save["mood"] >= -50 and gbData.data.save["trust"] >= 30:
		GlobalVariable.petf(true)
		GlobalVariable.raisemoodF(2.5)
	else:
		GlobalVariable.petf(false)


func _on_temp_feed_pressed() -> void:
	if gbData.data.save["hunger"] < 90:
		gbData.data.save["hunger"] = min(gbData.data.save["hunger"] + 10, 100.0)
		gbData.data.save["trust"] = min(gbData.data.save["trust"] + 5, 100.0)
		GlobalVariable.feedf(1)
		GlobalVariable.raisemoodF(1)


func _on_button_pressed() -> void:
	if clickthrough:
		clickthrough.change(false)
	self.queue_free()
