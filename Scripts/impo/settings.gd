extends Node

# thank you randoms on discord
@onready

var settings = gbData.settings
@export var list: Control


@export var partent: Control
var sMAP = {
	"deathBool": {"key": "invincible", "type": "toggle"},
	"lobotomize": {"key": "lobotomize", "type": "toggle"},
	"expiePersistence": {"key": "expiePersistence", "type": "toggle"},
	"pixel": {"key": "pixel", "type": "toggle"},
	"expieFontSize": {"key": "expieDialogueSize", "type": "text"},
	"hungerRate": {"key": "hungerDecayRate", "type": "text"},
	"openAlert": {"key": "messageEnabled", "type": "toggle"},
	"mute": {"key": "mute", "type": "toggle"},
	"dialogueSoundBool": {"key": "dialogueSoundEnabled", "type": "toggle"},
	"minMood": {"key": "minMood", "type": "text"},
	"maxMood": {"key": "maxMood", "type": "text"},
	"normalize": {"key": "normalize", "type": "text"},
	"soundVolume": {"key": "soundVolume", "type": "slider"},
	"defaultSkin": {"key": "defaultSkin", "type": "string"},
}


func _ready() -> void:
	if gbData.devMode:
		#print("Settings ", settings)
		pass
	_initset()
	
	_on_general_tab_pressed() # pretend that general was just pressed


func _initset() -> void:
	$VSplitContainer/ScrollContainer.custom_minimum_size = partent.size
	for node_name in sMAP:
		var node = findSettingN(node_name)
		if node == null:
			continue

		var entry = sMAP[node_name]
		var key = entry["key"]
		var type = entry["type"]

		match type:
			"toggle":
				node.button_pressed = settings.get(key, false)
				node.toggled.connect(func(on): sett(key, on))

			"text":
				node.text = str(settings.get(key, ""))
				node.text_submitted.connect(func(val): sett(key, float(val)))

			"string":
				node.text = str(settings.get(key, ""))
				node.text_submitted.connect(func(val): sett(key, val))

			"slider":
				node.value = settings.get(key, node.min_value)
				node.value_changed.connect(func(val): sett(key, val))


# 
func findSettingN(node_name: String) -> Node:
	for child in list.get_children():
		if child.name == node_name:
			return child
	return null


func sett(key: String, value) -> void:
	settings[key] = value
	_saveSettings()


func _saveSettings() -> void:
	$ScrollContainer.custom_minimum_size = partent.size
	gbData.savetodisk(gbData.conPath, gbData.settings)
	if gbData.devMode:
		print("Settings saved")


func _on_expie_persistence_pressed():
	if gbData.settings.expiePersistence:
		gbData.data["save"]["expies"] = gbData.temp["expies"]
	else:
		gbData.temp["expies"] = {}
		gbData.data["save"]["expies"] = {}


### Tab handling:
## This is VERY hard-coded, so adding a new tab is a bit of a process. sry abt that. Hopefully I re-write at some point :P

@export var GeneralTabN: Button
@export var AudioTabN: Button

func get_tab_nodes(TabName):
	var results: Array[Node] = []
	var children: Array[Node] = $VSplitContainer/ScrollContainer/ItemList.get_children()

	for child in children:
		if child.has_meta("Tab"):
			if child.get_meta("Tab") == TabName:
				results.append(child)
	return results

func hide_all_settings():
	for child in $VSplitContainer/ScrollContainer/ItemList.get_children():
		child.visible = false

func _on_general_tab_pressed():
	$VSplitContainer/TabsScrollContainer/HBoxContainer/AudioTab.button_pressed = false
	hide_all_settings()
	var GeneralSettings = get_tab_nodes("General")
	for node in GeneralSettings:
		node.visible = true

func _on_audio_tab_pressed():
	$VSplitContainer/TabsScrollContainer/HBoxContainer/GeneralTab.button_pressed = false
	hide_all_settings()
	var AudioSettings = get_tab_nodes("Audio")
	for node in AudioSettings:
		node.visible = true
