extends Node

@onready var hungry: float = gbData.data.save.hunger

var maxhunger := 100.0
var minhunger := 0.0
#@onready var trust: float = gbData.data.save.trust


func hungercheck():
		if gbData.settings["hungerEnabled"]:
			#await get_tree().create_timer(5).timeout
			hungry -= 0.1
			print(str(hungry) + "hunger")
			hungry = clamp(hungry, minhunger, maxhunger)
			pass
			return hungry
		else:
			return 50
