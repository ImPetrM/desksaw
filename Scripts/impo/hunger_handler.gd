extends Node

var maxhunger := 100.0
var minhunger := 0.0

#@onready var trust: float = gbData.data.save.trust
func hungercheck():
		if gbData.settings["hungerEnabled"]:
			var petId = get_parent().petId
			var hungry = gbData.data.saw[petId].hunger

			hungry -= 0.1
			print(str(hungry) + " hunger")
			hungry = snappedf(hungry, 0.01)
			hungry = clamp(hungry, minhunger, maxhunger)
			gbData.data.saw[petId].hunger = hungry
			gbData.savetodisk("user://SAVE.json", gbData.data)
			pass
			return hungry
		else:
			return 50
