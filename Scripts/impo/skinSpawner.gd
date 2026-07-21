extends Container

@onready var SkinNameN = $GridContainer/SkinName
var SkinFolders = []
var skinIndx = 0

func _ready():
	SkinNameN.text = "Default skin (Body):"
	skinFolderScan()
	mapSkin()
	loadAllTextures()


func skinFolderScan():
	SkinFolders = []
	print("Scanning for folders in skin...")
	var dir = DirAccess.open("user://skin")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
				SkinFolders.append(file_name)
			file_name = dir.get_next()
	else:
		print("You don't got any skins buddy")
	print("Scan Finished. Found: ", SkinFolders)

func refreshDisplayExpie():
	userSkinPath = "user://skin/" + SkinFolders[skinIndx] + "/"
	print(userSkinPath)
	mapSkin()
	loadAllTextures()
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


func _on_folder_access_pressed():
	OS.shell_open(ProjectSettings.globalize_path("user://skin"))

func _on_previous_pressed():
	skinFolderScan()
	skinIndx -= 1
	if skinIndx == -1: skinIndx = len(SkinFolders)-1
	refreshDisplayExpie()

func _on_next_pressed():
	skinFolderScan()
	skinIndx += 1
	if skinIndx == len(SkinFolders): skinIndx = 0
	refreshDisplayExpie()

func _on_select_pressed():
	GlobalVariable.userSkinPath = "user://skin/" + SkinFolders[skinIndx] + "/"
	spawnExpie()


# ik, ik, this is shitty implementation of the skin system here, but im tired...

@export
var currtextures: Array = []
@export
var alltextures: Array = []
#paths
var resPath = "res://assets/Body/"
var userSkinPath = "user://skin/Body/"
#furry boyfirend
signal mappe(currtextures: Dictionary)

func mapSkin():
	var skinList = gbData.skinData

	currtextures.clear()
	var sprites = getspr($DisplayExpie)

	var skinFileNames = {}
	if skinList.size() == 0:
		print("no skin stuff deteckted")
	else:
		for skinPath in skinList:
			var fileName = skinPath.get_file()
			skinFileNames[fileName] = true

	for sprite in sprites:
		sprite.flip_v = false
		var appliedTex = swapTex(sprite, skinFileNames)
		if appliedTex:
			currtextures.append(appliedTex)

	mappe.emit(currtextures)


func swapTex(sprite: Sprite2D, skinFileNames: Dictionary):
	var tex = sprite.texture
	if tex == null:
		return null

	var file_name = tex.resource_path.get_file()

	if not skinFileNames.has(file_name):
		return {
			"name": file_name,
			"texture": tex
		}

	var new_path = userSkinPath + file_name
	var new_tex = loadUserTex(new_path)

	if new_tex:
		sprite.texture = new_tex
		return {
			"name": file_name,
			"texture": new_tex
		}

	return {
		"name": file_name,
		"texture": tex
	}
func loadUserTex(userPath: String):
	if not FileAccess.file_exists(userPath):
		return null

	var image = Image.new()
	var loadResult = image.load(userPath)

	if loadResult != OK:
		return null

	return ImageTexture.create_from_image(image)

func getspr(node: Node) -> Array:
	var found = []
	for child in node.get_children():
		if child is Sprite2D:
			found.append(child)
		found.append_array(getspr(child))
	return found

func getAppliedTextures() -> Array:
	return currtextures

func loadAllTextures():
	alltextures.clear()

	var dir := DirAccess.open(resPath)
	if dir == null:
		print("DIR OPEN FAILED: ", resPath)
		return

	dir.list_dir_begin()

	while true:
		var entry = dir.get_next()
		if entry == "":
			break

		if dir.current_is_dir():
			continue

		var file: String

		if entry.ends_with(".import"):
			file = entry.get_basename()
		elif entry.get_extension() in ["png", "jpg"]: # fir debugging
			file = entry
		else:
			continue

		var tex: Texture2D
		var user_tex = loadUserTex(userSkinPath + file)
		if user_tex:
			tex = user_tex
		else:
			tex = load(resPath + file)

		if tex:
			alltextures.append({
				"name": file,
				"texture": tex
			})

	dir.list_dir_end()
