@tool
extends PanelContainer

@export_category("Settings")
## Text to be shown alongside the checkbox.
@export_multiline var label: String:
	set(new_label):
		label = new_label
		_update_label()
## Config. key to change when switching the checkbox.
@export var key: String

@export_category("Values")
@export var values: Array[String]
@export var selectedValue: String
@export var defaultValue: String

@export_category("Nodes - DONT CHANGE")
@export var _optionButton: OptionButton
@export var _label: Label

func refresh() -> void:
	_update_label()
	_update_state()
	
func _update_state() -> void:
	var init_v = gbData.settings.get(key)
	if init_v == null:
		# if the key doesn't exist, create it!
		_init_variable(false)
		selectedValue = defaultValue
	elif !(init_v is String):
		# if the key is not a boolean, fuss about it!
		push_error("Key '%s' is not a string! checkbox widgets are not made for these!" % [key])
		# for the sake of preventing confusion, we won't initiate the variable on
		# failure to load. instead, make sure you're not mixing up key types and widgets!
	else:
		# update starting pressed state according to value
		var value: String = init_v
		selectedValue= value


func _init_variable(save: bool = false) -> void:
	gbData.settings.set(key, defaultValue)
	if save:
		gbData.savetodisk(gbData.conPath, gbData.settings)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not Engine.is_editor_hint():
		refresh()
		#_checkbox.toggled.connect(_on_check_box_toggled)
		#GlobalVariable.dataNuked.connect(_read_refresh)
	
	var index = 0
	for item in values:
		_optionButton.add_item(item, index)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _update_label() -> void:
	# this function is called before the label can ready up, which is
	# prettyy annoying. couldn't find a proper way to call this once.
	if not _label:
		return
	_label.text = label


func _on_option_button_item_selected(index: int) -> void:
	pass # Replace with function body.
