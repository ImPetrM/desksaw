extends Node


@onready var faceSys = $faceHandler
@onready var moodSys = $moodHandler
@onready var moveSys = $movementHandler
@onready var dialogueSys = $dialogue

@onready var data = gbData.text.diaGlobal

@onready var settings = gbData.settings
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	moveSys.randomdir()
	faceSys.setEmotion("default")

	#panicAttack()

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func panicAttack():
	if moodSys.tick > -4.5 or moodSys.mood >= 20.0 or settings.lobotomize:
		return


	#run towards one side of the screen
	faceSys.setEmotion("sad")
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
	
	
func checkifnearborder():
	while true:
			await get_tree().create_timer(randf_range(10.0, 25.5)).timeout
			dialogueSys.pool = data.HappyPassive
			dialogueSys.speedMod = 1.3
			dialogueSys.send()
