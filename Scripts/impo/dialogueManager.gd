extends Node
class_name Dialogue

@onready var data = gbData.text.diaGlobal
@export var richtextlabel: RichTextLabel
@export var textspeed: float = 0.04

var pause: Array = [",", ".", "!"]
var isTyping: bool = false
@onready var mood = gbData.data.save.mood
var pool: Array = []
var speedMod: float = 1.0

signal starttalking()
signal stoptalking()

var tre: int = 0
# 1. Create a variable to track our background routine
var passive_timer: SceneTreeTimer = null

func _ready() -> void:
	richtextlabel.visible_characters = 10
	richtextlabel.add_theme_font_size_override("normal_font_size", gbData.settings.expieDialogueSize)
	run_passive_sequence() # Changed name to represent the full sequence

func typeOut(string: String, speed_multiplier: float = 1.0):
	tre += 1
	var h = tre

	richtextlabel.add_theme_font_size_override("normal_font_size", gbData.settings.expieDialogueSize)
	isTyping = true
	richtextlabel.text = string
	richtextlabel.visible_characters = 0

	starttalking.emit()

	var i = 0
	while i < string.length():
		if tre != h: return

		if string[i] == "[":
			while i < string.length() and string[i] != "]":
				i += 1
			i += 1
			continue

		richtextlabel.visible_characters += 1
		var current_char = string[i]

		var wait = textspeed * speed_multiplier
		if current_char in pause:
			wait *= 8

		await get_tree().create_timer(wait).timeout
		i += 1

	if tre != h: return

	isTyping = false
	stoptalking.emit()
	await get_tree().create_timer(string.length() * 0.2).timeout

	if tre == h:
		richtextlabel.visible_characters = 0

func send():
	if pool.size() > 0:
		typeOut(pool.pick_random(), speedMod)

# 2. Optimized, safe sequence runner
func run_passive_sequence():
	# First Delay
	passive_timer = get_tree().create_timer(randi_range(12, 15))
	await passive_timer.timeout
	if not is_inside_tree(): return # Prevents crashes if node was destroyed
	
	pool = data.seq1
	speedMod = 1.2
	send()

	# Second Delay
	passive_timer = get_tree().create_timer(5)
	await passive_timer.timeout
	if not is_inside_tree(): return
	
	pool = data.seq2
	speedMod = 1.2
	send()
