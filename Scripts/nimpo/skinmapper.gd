extends Node

@export
var bodyRoot: NodePath
@export
var currtextures: Array = []
#paths
var resPath = "res://assets/Body/"
var userSkinPath = "user://skin/Body/"

signal mappe(currtextures: Dictionary)
func _ready() -> void:
	mapSkin()

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

	var fileName = tex.resource_path.get_file()
	if not skinFileNames.has(fileName):
		return tex # no matching skin entry (or no skin at all) — keep default

	var newPath = userSkinPath + fileName
	var newTex = loadUserTex(newPath)

	if newTex:
		sprite.texture = newTex
		return newTex
	else:
		print("could not load:", newPath)
		return tex
		
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
