extends Node

@onready var hungry: float = 0.0


@export var mouth: RapierArea2D
var maxhunger := 100.0
var minhunger := 0.0
#@onready var trust: float = gbData.data.save.trust
var petId: String = ""
var pet
@export var dialogue: Node
func loadFromSave(id: String) -> void:
	petId = id
	pet = gbData.data["saw"][petId]
	hungry = pet.get("hunger", hungry)


func hungercheck():
		if gbData.settings["hungerEnabled"]:
			#await get_tree().create_timer(5).timeout
			hungry -= 0.05
			#print(str(hungry) + " hunger")
			hungry = snappedf(hungry, 0.01)
			hungry = clamp(hungry, minhunger, maxhunger)
			pet.hunger = hungry
			gbData.savetodisk("user://SAVE.json", gbData.data)
			pass
			return hungry
		else:
			return maxhunger


func _onItemEnter(body: Node2D) -> void:
	if not body.has_node("properties"):
		return

	var props = body.get_node("properties").propertyTable

	if not props.consumable:
		return

	if props.tasteIfConsumable == 0:
		dialogue.pool = gbData.text.diaGlobal.EatReject
		dialogue.send()
		return

	hungry += props.replenishIfConsumable
	self.get_parent().moodSys.mood += props.moodBoostIfConsumable
	dialogue.pool = _getTasteDialogue(props.tasteIfConsumable)
	dialogue.send()

	body.queue_free()


func _getTasteDialogue(taste: int) -> Array:
	if taste <= 3:
		return gbData.text.diaGlobal.EatBad
	elif taste <= 6:
		return gbData.text.diaGlobal.EatOk
	else:
		return gbData.text.diaGlobal.EatGood

"""
					dialogueSys.pool = data.sleepy
					dialogueSys.send()
					"""
