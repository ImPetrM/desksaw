extends Node

@export var window: Control
@export var stat = {
	"mood": 0.0,
	"hunger": 0.0,
	"sleep": 0.0,
}

func _ready() -> void:
	upd(stat)

func upd(stats: Dictionary) -> void:
	#var ilist = window.get_node("ItemList")
	#var textTemplate = window.get_node("ItemList/stat")
	
	var moodProgress : ProgressBar = window.get_node("ItemList/StatsContainer/MoodContainer/MoodProgressBar")
	moodProgress.value =  stats.get("mood", 0.0)
	
	var hungerProgress : ProgressBar = window.get_node("ItemList/StatsContainer/HungerContainer/HungerProgressBar")
	hungerProgress.value = stats.get("hunger", 0.0)
	
	var sleepProgress : ProgressBar = window.get_node("ItemList/StatsContainer/SleepContainer/SleepProgressBar")
	moodProgress.value = stats.get("sleep", 0.0)

	"""
	for child in ilist.get_children():
		if child != textTemplate:
			child.queue_free()
	

	for key in stats.keys():
		#update asdfhsdfuioghj
		var val = stats[key]
		var new_stat = textTemplate.duplicate()
		

		new_stat.show()
		new_stat.text = str(key) + ": " + str(val)
		ilist.add_child(new_stat)
		"""

func _process(_delta: float) -> void:
	pass
