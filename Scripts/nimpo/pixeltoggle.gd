extends CanvasLayer

@onready

var settings = gbData.settings
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	if visible != settings.pixel:
		visible = settings.pixel
