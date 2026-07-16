extends Node

@export
var bodyRoot: NodePath
@export
var currtextures: Array = []
@export
var alltextures: Array = []
#paths
var resPath = "res://assets/Body/"
var userSkinPath = "user://skin/Body/"
#furry girlfirend 
signal mappe(currtextures: Dictionary)
func _ready() -> void:
	mapSkin()
	loadAllTextures()

func mapSkin():
	var skinList = gbData.skinData

	currtextures.clear()
	var root = get_node(bodyRoot)
	var sprites = getspr(root)

	var skinFileNames = {}
	if skinList.size() == 0:
		print("no skin stuff deteckted")
	else:
		for skinPath in skinList:
			var fileName = skinPath.get_file()
			skinFileNames[fileName] = true

	for sprite in sprites:
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
		return

	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break

		if dir.current_is_dir():
			continue

		if file.get_extension() in ["png", "webp", "jpg"]:
			var tex: Texture2D


			var user_tex = loadUserTex(userSkinPath + file)
			if user_tex:
				tex = user_tex
			else:
				tex = load(resPath + file)

			alltextures.append({
				"name": file,
				"texture": tex
			})

	dir.list_dir_end()