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
	

	if gbData.settings["messageEnabled"]:
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
	
	if gbData.settings["expiePersistence"]:
		gbData.temp.expies = gbData.data["save"]["expies"]
		loadExpiePersistence()

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


func loadExpiePersistence():
	print("loading expies...")
	print(gbData.data["save"]["expies"])
	for name in gbData.data["save"]["expies"]: # expie names
		print("loading '", name, "' skin expies...")
		for i in range(gbData.data["save"]["expies"][name]): # number of expies to spawn for name
			if gbData.temp["firstSpawn"]: gbData.temp["firstSpawn"] = false; print("skipped first expie."); continue # check if first expie, as to not duplicate one already spawned
			await get_tree().create_timer(0.25).timeout
			GlobalVariable.userSkinPath = "user://skin/" + name + "/"
			$CanvasLayer2/ConsoleContainer/Main/ConsoleContainer/Commands.spawnExpie() # call spawn function from commands
			print("loaded ", name, " - ", i)
			gbData.data["save"]["expies"][name] -= 1 # decreases number to be spawned, so no duplication
