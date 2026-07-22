extends Container

@export var test: Control
@onready var SkinNameN = $GridContainer/SkinName
var SkinFolders = []
var skinIndx = 0

func _ready():
	SkinNameN.text = "Body:"
	skinFolderScan()
	refreshDisplayExpie()


func skinFolderScan():
	SkinFolders = []
	var dir = DirAccess.open("user://skin")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				SkinFolders.append(file_name)
			file_name = dir.get_next()
	else:
		print("You don't got any skins buddy")
	print("Looked for skin folders. Found: ", SkinFolders)

func refreshDisplayExpie():
	GlobalVariable.userSkinPath = "user://skin/" + SkinFolders[skinIndx] + "/"
	reloadDisplayExpie()
	SkinNameN.text = SkinFolders[skinIndx] + ":"

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
	wrapper.set_meta("entity", false)

func reloadDisplayExpie():
	get_parent().get_node("SkinSpawner").get_children()
	for child in get_parent().get_node("SkinSpawner").get_children():
		if child.has_meta("display"):
			child.queue_free()
	
	var path = "res://scenes/displayExpie.tscn"
	var scene = load(path)
	var instance = scene.instantiate()
	var wrapper = Node2D.new()
	
	get_tree().current_scene.add_child(wrapper)
	wrapper.owner = get_tree().current_scene

	wrapper.add_child(instance)
	instance.owner = get_tree().current_scene
	
	wrapper.set_meta("display", false)
	
	var child_node = wrapper
	if child_node.get_parent():
		child_node.get_parent().remove_child(child_node)
	add_child(wrapper)

func _on_folder_access_pressed():
	OS.shell_open(ProjectSettings.globalize_path("user://skin"))

func _on_refresh_pressed():
	skinIndx = 0
	skinFolderScan()
	refreshDisplayExpie()

func _on_previous_pressed():
	skinIndx -= 1
	if skinIndx == -1: skinIndx = len(SkinFolders)-1
	refreshDisplayExpie()

func _on_next_pressed():
	skinIndx += 1
	if skinIndx == len(SkinFolders): skinIndx = 0
	refreshDisplayExpie()

func _on_select_pressed():
	GlobalVariable.userSkinPath = "user://skin/" + SkinFolders[skinIndx] + "/"
	spawnExpie()
