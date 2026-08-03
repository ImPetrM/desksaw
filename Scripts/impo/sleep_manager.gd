extends Node

var petId: String
var tiredness: float

var maxtired := 100.0
var mintired := 0.0
#@onready var trust: float = gbData.data.save.trust
var likelihood := 0

func sleepCheck():
		if gbData.settings["sleepEnabled"]:
			#await get_tree().create_timer(5).timeout
			petId = get_parent().petId
			tiredness = gbData.data.saw[petId].tired
			print(str(tiredness) + " tiredness")
			tiredness = snappedf(tiredness, 0.01)
			tiredness = clamp(tiredness, mintired, maxtired)
			gbData.data.saw[petId].tired = tiredness

			if !self.get_parent().isSleeping:
				tiredness += 0.15
			gbData.savetodisk("user://SAVE.json", gbData.data)
			pass
			return tiredness
		else:
			return maxtired