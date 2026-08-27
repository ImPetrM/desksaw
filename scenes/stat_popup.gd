extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_stats({})


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_stats(stats : Dictionary):
	$ItemList/StatsNameLabel.text = "#%d" % int(stats.get("id", 0))
	$ItemList/StatsContainer/MoodContainer/MoodProgressBar.value = stats.get("mood", 0.0)
	$ItemList/StatsContainer/HungerContainer/HungerProgressBar.value = stats.get("hunger", 0.0)
	$ItemList/StatsContainer/SleepContainer/SleepProgressBar.value = stats.get("sleep", 0.0)
