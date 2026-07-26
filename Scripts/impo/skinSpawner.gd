extends Container

@export var test: Control
@onready var SkinNameN = $GridContainer/SkinName
var SkinFolders = []
var skinIndx = 0

func _ready():
	SkinNameN.text = "Default:"
	skinFolderScan()
	call_deferred("refreshDisplayExpie")


func skinFolderScan():
	SkinFolders = ["Default"]
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
	if len(SkinFolders) == 1:
		print("Looked for skin folders. Found None.")
	else:
		print("Looked for skin folders. Found: ", SkinFolders.slice(1))

func refreshDisplayExpie():
	if skinIndx == 0:
		GlobalVariable.userSkinPath = "res://skin/Body/"
	else:
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
	for child in get_children():
		if child.has_meta("display"):
			child.queue_free()

	var scene = load("res://scenes/displayExpie.tscn")
	var instance = scene.instantiate()
	var disp = instance.get_node_or_null("DisplayExpie")
	if disp:
		disp.position = Vector2(90, 60)
	var wrapper = Node2D.new()
	wrapper.set_meta("display", false)
	wrapper.add_child(instance)
	add_child(wrapper)

func _on_folder_access_pressed():
	OS.shell_open(ProjectSettings.globalize_path("user://skin"))

func _on_refresh_pressed():
	skinIndx = 0
	skinFolderScan()
	
	# refresh skinData, as to update expie only being a head
	var _ifliterallyanythingisthere = false
	var added = []
	var pt = gbData.skinfilepath + "/Body"
	if DirAccess.dir_exists_absolute(pt):
		var files = DirAccess.get_files_at(pt)
		for file in files:
			if file.get_extension().to_lower() == "png":
				_ifliterallyanythingisthere = true
				added.append(gbData.skinfilepath.path_join(file))
	added = gbData.skinData
	
	refreshDisplayExpie()

func _on_previous_pressed():
	skinIndx -= 1
	if skinIndx == -1: skinIndx = len(SkinFolders)-1 # if we go under min index, loop to max
	refreshDisplayExpie()

func _on_next_pressed():
	skinIndx += 1
	if skinIndx == len(SkinFolders): skinIndx = 0 # if we go over max index, loop to 0
	refreshDisplayExpie()

func _on_select_pressed():
	GlobalVariable.userSkinPath = "user://skin/" + SkinFolders[skinIndx] + "/"
	spawnExpie()


