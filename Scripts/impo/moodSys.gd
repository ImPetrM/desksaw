extends Node
# yeah
# mood system or whatevah
# oh gosh

@export var tick: float = 0
@export var eyeNode: Sprite2D
@export var mouthNode: Sprite2D


@onready var mood: float = gbData.data.save.mood
@onready var trust: float = gbData.data.save.trust


@onready
var minmood = gbData.settings["minMood"]
@onready
var maxmood = gbData.settings["maxMood"]

func _ready() -> void:
	#initializeloops and signals
	moodLoop()



#make sure things are updated

func _sync_mood() -> void:
	#gbData.data.save.mood = mood
	minmood = gbData.settings["minMood"]
	maxmood = gbData.settings["maxMood"]
	gbData.savetodisk("user://SAVE.json", gbData.data)


#main mood loop
func moodLoop() -> void:
	while true:
		await get_tree().create_timer(3).timeout

		var normalize = mood / 250.0

		#clamp the tickrate to 5
		tick = clamp(tick, -5.0, 5.0)


		#test.emit()

		#clamp to min and maxmood
		mood = clamp(lerp(mood, 0.0, 0.01) + tick, minmood, maxmood)
		#showly neutralize in lerp but im going to be honesst they basically do nothing
		tick = lerp(tick, 0.0, 0.01)
		#round
		mood = snappedf(mood, 0.01)

		_sync_mood()

		if gbData.devMode:
			print(str("mood: ", mood))
			print(str("tick: ", tick))
