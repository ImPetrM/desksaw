extends Node

@onready var tiredness: float = gbData.data.save.tired

var maxtired := 100.0
var mintired := 0.0
#@onready var trust: float = gbData.data.save.trust
var likelihood := 0

func sleepCheck():
		if gbData.settings["sleepEnabled"]:
			#await get_tree().create_timer(5).timeout
			tiredness += 0.15
			print(str(tiredness) + " tiredness")
			tiredness = snappedf(tiredness, 0.01)
			tiredness = clamp(tiredness, mintired, maxtired)
			gbData.data.save.tired = tiredness
			gbData.savetodisk("user://SAVE.json", gbData.data)
			pass
			return tiredness
		else:
			return maxtired
