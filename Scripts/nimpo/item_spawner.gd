#reused from other game Fishy
#nvm ill just rewrite it

extends Container
#define item shit
#var items = []
var itemsPath = "res://scenes/objects/"

@onready
var itemTemplate = $ScrollContainer/iList/Button

@onready
var list = $ScrollContainer/iList

func _ready() -> void:
	$ScrollContainer.custom_minimum_size = get_parent().size
	itemTemplate.visible = false
	scanItems()


func _process(delta: float) -> void:
	pass

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
