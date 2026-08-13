#reused from other game Fishy
#nvm ill just rewrite it

extends Container
#define item shit
#var items = []


#since godot wants to bitch about exporting this item list will remain until it does
#this exact bug messed up my first game jam submission but basically it doesnt like when you reference res files in the exported build and then it just
#treats them as if they dont exist


#unfortunately due to this, objects have to be referenced MANUALLY. defeating the whole purpose of this script
#why ME
@export var itemScenes: Array[PackedScene] = [
	preload("res://scenes/objects/crate.tscn"),
	preload("res://scenes/objects/geofruit.tscn"),
	preload("res://scenes/objects/pizzaslice.tscn"),
	preload("res://scenes/objects/sawblade.tscn"),
	
]


var itemsPath = "res://scenes/objects/"

@onready
var itemTemplate = $ScrollContainer/iList/Button

@onready
var list = $ScrollContainer/iList

func _ready() -> void:
	$ScrollContainer.custom_minimum_size = get_parent().size
	itemTemplate.visible = false
	scanItems()

# redo the previous functions (commented out below). kinda copied what i did for the aforementioned game that got fucked by godot not liking this kind of exporting
func scanItems():
	#items.clear()
	for scene in itemScenes:
		if scene == null:
			continue
		var itemName = scene.resource_path.get_file().get_basename()
		var image = getSceneTexture(scene)
		makeButtons(itemName, image, scene)

func getSceneTexture(scene: PackedScene):
	#look inside the scene for a Sprite2D node thats a direct parent of the root
	#copy the texture and store it in 
	var instance = scene.instantiate()
	var image: Texture = null
	for i in instance.get_children():
		if i is Sprite2D:
			image = i.texture
			break
	instance.queue_free()
	return image
#actually make the button
func makeButtons(itemName: String, texture: Texture, scene: PackedScene) -> void:
	var newbutton = itemTemplate.duplicate()
	newbutton.visible = true
	list.add_child(newbutton)
	newbutton.get_node("name").text = itemName
	newbutton.get_node("TextureRect").texture = texture

	#connect to the add command
	newbutton.pressed.connect(_additem.bind(scene, itemName))
	
#temporarily commenting all of this out until godot finds a fix
"""


#get items inside it

func scanItems():
	#items.clear()
	var dir = DirAccess.open(itemsPath)
	if dir == null:
		return

	dir.list_dir_begin()
	var nameF = dir.get_next()
	while nameF != "":
		if !dir.current_is_dir() and nameF.ends_with(".tscn"):
			var itemName = nameF.get_basename()
			var scenePath = itemsPath + nameF
			var image = getSceneTexture(scenePath)
			print(itemName)
			#items.append(itemName)
			makeButtons(itemName, image)

		nameF = dir.get_next()
	dir.list_dir_end()


func getSceneTexture(scenePath: String):
	var scene = load(scenePath)
	if scene == null:
		return null

	var instance = scene.instantiate()
	var image: Texture = null
	#look inside the scene for a Sprite2D node thats a direct parent of the root
	#copy the texture and store it in 
	for i in instance.get_children():
		if i is Sprite2D:
			image = i.texture
			break

	instance.queue_free()
	return image
#actually make the button

func makeButtons(itemName: String, texture: Texture) -> void:
	var newbutton = itemTemplate.duplicate()
	newbutton.visible = true
	list.add_child(newbutton)

	newbutton.get_node("name").text = itemName
	newbutton.get_node("TextureRect").texture = texture
	#connect to the add command
	newbutton.pressed.connect(_additem.bind(itemName))
"""

#literally just the one from commands.gd word for wrd

func _additem(item: String = "crate"):
	var path = "res://scenes/objects/" + item + ".tscn"
	if !ResourceLoader.exists(path):
		Console.error("No such object '" + item + "'")
		return
	var scene = load(path)
	var instance = scene.instantiate()
	get_tree().current_scene.add_child(instance)
	instance.global_position = instance.get_global_mouse_position()
	instance.owner = get_tree().current_scene
	instance.set_meta("itemName", item)
