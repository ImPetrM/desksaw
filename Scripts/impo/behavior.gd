extends Node


@onready var faceSys = $faceHandler
@onready var moodSys = $moodHandler
@onready var moveSys = $movementHandler
@onready var dialogueSys = $dialogue

@onready var data = gbData.text.diaGlobal

@onready var settings = gbData.settings
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	panicAttack(-100.0)
	moveSys.randomdir()
	faceSys.setEmotion("sad")
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func panicAttack(mood: float):
	faceSys.setEmotion("sad")

	
	await get_tree().create_timer(8).timeout
	if mood >= -40.0:
		#idk bro theyre overreacting
		return
	if settings.lobotomize:
		return
	#run towards one side of the screen
	if moveSys.rigid.global_position.x < float(GlobalVariable.screenWidth / 2): moveSys.dir = 1
	else: moveSys.dir = -1

	dialogueSys.pool = data.VeryLowPassive
	dialogueSys.speedMod = 1.3
	dialogueSys.send()

	await get_tree().create_timer(3).timeout

	moveSys.dir = 0
	dialogueSys.pool = data.panic
	dialogueSys.speedMod = 1.3
	dialogueSys.send()
	await get_tree().create_timer(1).timeout
	moveSys.animplay.play("dance")

	await get_tree().create_timer(2).timeout
	ohno()
	

func checkifnearborder():
	var pos = moveSys.rigid.globalpo


func ohno():
	while true:
			dialogueSys.pool = data.VeryLowPassive
			dialogueSys.speedMod = 1.3
			dialogueSys.send()
			await get_tree().create_timer(10).timeout
