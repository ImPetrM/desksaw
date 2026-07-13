extends Node

class_name Dialogue
@onready
var data = gbData.text.diaGlobal

@export
var richtextlabel: RichTextLabel

@export
var textspeed: float = 0.04


#@export
#AnimationPlayer
#the stuff that will cause the text to delay
var pause: Array = [

	",",
	".",
	"!"
	#etc

]

#guess what this does
var isTyping: bool = false
@onready
var mood = gbData.data.save.mood
var pool: Array = []
var speedMod: float = 1.0
signal starttalking()
signal stoptalking()


func _ready() -> void:
	passive()
	richtextlabel.visible_characters = 10
	richtextlabel.add_theme_font_size_override("normal_font_size", gbData.settings.expieDialogueSize)


#ripped straight from a tutorial

var tre: int = 0

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
			if tre != h:
				return

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

		if tre != h:
			return
			

		isTyping = false
		stoptalking.emit()
		await get_tree().create_timer(string.length() * 0.2).timeout

		if tre == h:
			richtextlabel.visible_characters = 0
func send():
	if pool.size() > 0:
		typeOut(pool.pick_random(), speedMod)


func passive():
	while true:
		await get_tree().create_timer(3).timeout
		pool = data.suffering
		speedMod = 1.2
		print("ow")
		send()
