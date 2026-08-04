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

#for temporary events
var tempOffset: float = 0.0
#make sure things are updated

func _sync_mood() -> void:
	#gbData.data.save.mood = mood
	minmood = gbData.settings["minMood"]
	maxmood = gbData.settings["maxMood"]
	gbData.savetodisk("user://SAVE.json", gbData.data)

func _tempVal(offset: float = 0.0, decayLength: float = 0.0):
	tempOffset = offset
	var tween := create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "tempOffset", 0.0, decayLength)
	pass
#main mood loop
func moodCheck():
		#await get_tree().create_timer(10).timeout
		if gbData.settings.get("invincible", false):
			return

		mood += calcmood(1)
		#showly neutralize in lerp but im going to be honesst they basically do nothing

		mood = snappedf(mood, 0.01)


		mood = clamp(mood, minmood, maxmood)

		mood = lerp(mood + tempOffset, 0.0, 0.01)
		if gbData.devMode:
			print(str("mood: ", mood))
			print(str("tick: ", calcmood(1.0)))
		if gbData.settings["lobotomize"]:
			mood = 0.0

		_sync_mood()
		
		return mood

func tempCalc(total: float = 0.0):
	total -= clamp(((1.0 - (gbData.data.save["health"] * 0.01)) * 3), 0.0, 3)
	total = clamp(total, minmood, maxmood)
	return total

func calcmood(total: float):
	#health
	#hunger
	var mas = self.get_parent()
	if mas.ragdolled and not mas.isSleeping:
		if gbData.devMode:
			print("dragged so substract")
		total += 1.5
	total -= clamp(((1.0 - (gbData.data.save["hunger"] * 0.01)) * 1), 0.0, 1)
	#trust
	total -= clamp(((1.0 - (gbData.data.save["tired"] * 0.01)) * 1), 0.0, 1)
	print(str(clamp(((1.0 - (gbData.data.save["tired"] * 0.01)) * 1), 0.0, 1)) + " 123123")
	if gbData.data.save["hunger"] >= 85.0:
		total += 0.25
	#clamp to user settings
	total = clamp(total, minmood, maxmood)
	#undo all of it

	#print(total)
	return total
