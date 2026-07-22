extends Node2D

@onready
var settings = gbData.settings


var screenWidth: int = DisplayServer.screen_get_usable_rect().size.x
var screenHeight: int = DisplayServer.screen_get_usable_rect().size.y

var taskbarPos: int = DisplayServer.screen_get_usable_rect().end.y

@export
var console: Node
# Called when the node enters the scene tree for the first time.
func _ready():
	DisplayServer.window_set_size(Vector2i(screenWidth, screenHeight) - Vector2i(1, 1))
	DisplayServer.window_set_position(DisplayServer.screen_get_position())
	#i snooped around on a linux vm that uses wayland until the issue went away
	#forced it to run x11  and then changed the window setting when it runs linux
	#it works on my end. theres like 2 bajillion different versions of linux i know oneof them is bound to break
	#go bandage on amputated limb fix!
	if OS.get_name() == "Linux":
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)

	if OS.get_environment("XDG_SESSION_TYPE").to_lower() == "wayland":
		OS.alert("This message is popping up because you are using wayland. \n \n Most if not all features will not work due to wayland's security measures. \n\n You will have to have another x11 app running to interact with them (ex: Steam) or switch to x11\n\n Sorry! I dont know any workarounds );
")
	if gbData.settings["messageEnabled"] == true:
		OS.alert("DD14 here \n \n This build is for testing and has mood stuff disabled as they are a WIP. \n\n 
		 This is an open source project and I encourage you check out the development at https://github.com/dee-dee-catorce. \n\n

		 Build 2! this fixes a few bugs that were reported in build 1!

		 PS: Control + Click on the expie to reopen the menu
		Run openSkinFolder in the command section to start with skin stuff!
		 IM AWARE THAT THIS SHOULD NOT BE 200 MEGABYTES!!!!! ITS A GODOT THING IM WORKING ON FIXING!
")
	
	GlobalVariable.console.connect(yeah)
	#fix()
	createBorders()

	GlobalVariable.resize.connect(updateBorders)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func yeah(t: bool):
	console.visible = true
	console.showw()
	print("yeah")


func createBorders():
	taskbarPos = clampi(taskbarPos, 0, screenHeight)
	$Floor.position = Vector2(screenWidth / 2, taskbarPos)
	$SideL.position = Vector2(0, screenHeight / 2)
	$SideR.position = Vector2(screenWidth, screenHeight / 2)


func updateBorders():
	var oldheight = screenHeight
	screenWidth = DisplayServer.screen_get_usable_rect().size.x
	screenHeight = DisplayServer.screen_get_usable_rect().size.y
	taskbarPos = DisplayServer.screen_get_usable_rect().end.y

	DisplayServer.window_set_size(Vector2i(screenWidth, screenHeight) - Vector2i(1, 1))
	DisplayServer.window_set_position(DisplayServer.screen_get_position())
	for child in get_tree().current_scene.get_children():
			if child.has_meta("entity") or child.has_meta("object"):
				child.position.y -= screenHeight - oldheight
	createBorders()