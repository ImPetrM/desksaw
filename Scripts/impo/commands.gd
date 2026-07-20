extends Node

@export var root: Control

"""
    ###

    there was a bunch of bullshit planning on how i would go about this and there ended up being an addon that did literally
    everything i was planning on adding

    here you go

    https://github.com/4d49/godot-console


    this script just registers a bunch of commands and contains their the functions for their code

    to create a custom command, create a function that contains ur code, and then register it in _ready
    ###
"""

func _log(strang: String):
	return strang

func _cust(cmd: String):
	return cmd

func openskinfold():
	OS.shell_open(ProjectSettings.globalize_path("user://skin"))
	pass
func _setmood(val: float):
	gbData.data.save.mood = val
	gbData.savetodisk("user://SAVE.json", gbData.data)
	return val

func spawnExpie():
	var path = "res://scenes/sawianBase.tscn"
	var scene = load(path)
	var instance = scene.instantiate()

	var wrapper = Node2D.new()
	wrapper.scale = Vector2(4.0, 4.0)

	get_tree().current_scene.add_child(wrapper)
	wrapper.owner = get_tree().current_scene

	wrapper.add_child(instance)
	instance.owner = get_tree().current_scene

	instance.global_position.x = GlobalVariable.screenWidth / 2
	instance.global_position.y = - GlobalVariable.screenHeight * 2


func _additem(item: String = "crate"):
# add crate only for now
	var path = "res://scenes/objects/" + item + ".tscn"
	if !ResourceLoader.exists(path):
		Console.error("No such object '" + item + "'")
		return
	var scene = load(path)
	var instance = scene.instantiate()
	get_tree().current_scene.add_child(instance)
	instance.position = get_viewport().get_mouse_position()
	instance.owner = get_tree().current_scene

func resize(nx, ny):
	var ex = str(nx).to_float()
	var ey = str(ny).to_float()
	root.size.x = ex
	root.size.y = ey

	#save to config

	gbData.settings.ConsoleSize.x = ex
	gbData.settings.ConsoleSize.y = ey


	#debugshit
	if gbData.devMode == true:
		print(gbData.settings.ConsoleSize.x)
		print(gbData.settings.ConsoleSize.y)

	# please work please

	gbData.savetodisk("user://CONFIG.json", gbData.settings)
	return "resized"

func deathLoop():
	Console.execute("log I_HATE_YOU")
	await get_tree().create_timer(.1).timeout
	deathLoop()

func _ready():
	Console.create_command("log", _log, "Log a string to the console.")
	Console.create_command("resizeConsole", resize, "resize the console")
	##Console.create_command("killExpie", killExpie, "Yeha")
	Console.create_command("setMood", _setmood, "debugging tool that doesnt work because i disabled mood stuff for this build")
	Console.create_command("spawn", _additem, "items: crate, sawblade that doesnt do anything. yeah thats all. sorry")
	Console.create_command("spawnExpie", spawnExpie, "spawns another one of them. they cant interact yet.")
	Console.create_command("openSkinFolder", openskinfold, "opens the skin folder")
	#Console.create_command("deathLoop", deathLoop, "please dont crash")
	Console.execute("help")
	#setting stuff that would probably have a better solution to it

	applySettings()

func applySettings():
	## resize
	root.size.x = gbData.settings.ConsoleSize.x
	root.size.y = gbData.settings.ConsoleSize.y

func _scaleVisualsAndShapes(node: Node, factor: float) -> void:
	for child in node.get_children():
		if child is Sprite2D or child is AnimatedSprite2D:
			child.scale *= factor
		elif child is CollisionShape2D and child.shape:
			child.shape = child.shape.duplicate()
			if child.shape is CircleShape2D:
				child.shape.radius *= factor
			elif child.shape is RectangleShape2D:
				child.shape.size *= factor
			elif child.shape is CapsuleShape2D:
				child.shape.radius *= factor
				child.shape.height *= factor
			child.position *= factor
		_scaleVisualsAndShapes(child, factor)
