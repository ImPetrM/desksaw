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
	if gbData.settings["messageEnabled"] == true:
		OS.alert("DD14 here \n \n This build is for testing and has mood stuff disabled as they are a WIP. \n\n 
		 This is an open source project and I encourage you check out the development at https://github.com/dee-dee-catorce. \n\n

		 Also! this is the first test build! Thank you!

		 PS: Control + Click on the expie to reopen the menu
		Run openSkinFolder in the command section to start with skin stuff!
		 IM AWARE THAT THIS SHOULD NOT BE 200 MEGABYTES!!!!! ITS A GODOT THING IM WORKING ON FIXING!
")
	
	GlobalVariable.console.connect(yeah)
	#fix()
	createBorders()

	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func yeah(t: bool):
	console.visible = true
	console.showw()
	print("yeah")


func fix():
	#fallback incase the clickthrough number ever fucks itself
	#this was probably NOT at ALL the right way to do this
	while true:
		await get_tree().create_timer(.5).timeout
		#tagged out due to being a nuisaince
		#GlobalVariable.clickZoneSum = 0
	pass


func createBorders():
	taskbarPos = clampi(taskbarPos, 0, screenHeight)
	$Floor.position = Vector2(screenWidth / 2, taskbarPos)
	$SideL.position = Vector2(0, screenHeight / 2)
	$SideR.position = Vector2(screenWidth, screenHeight / 2)
