extends Node


func SetClickThrough(clickthrough: bool) -> void:
	GetWindow().MousePassthrough = true;
	print("passthrough now: ", DisplayServer.window_get_flag(DisplayServer.WINDOW_FLAG_MOUSE_PASSTHROUGH))
	Engine.max_fps = 60 if clickthrough else 60