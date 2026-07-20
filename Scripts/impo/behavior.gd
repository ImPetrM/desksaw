extends Node


@onready var faceSys = $faceHandler
@onready var moodSys = $moodHandler
@onready var moveSys = $movementHandler
@onready var dialogueSys = $dialogue

@onready var data = gbData.text.diaGlobal

@onready var settings = gbData.settings

var beingDragged = false
var ragdolled = false
var launchflag = false
var wander = true
var shocked = false

func _ready() -> void:
	faceSys.setEmotion("default")
	
	moveSys.sigragdoll.connect(shock)

	moveSys.rigid.global_position.x = GlobalVariable.screenWidth / 2
	moveSys.rigid.global_position.y = - GlobalVariable.screenHeight * 2
	tempRagdoll()
	wandering()
	passivetalk()

func _physics_process(delta: float) -> void:
	if not ragdolled and (abs(moveSys.rigid.linear_velocity.x) > moveSys.ragdollspeed or beingDragged):
		tempRagdoll()

	if ragdolled:
		moveSys.dir = 0

func shock():
	if shocked:
		return
	shocked = true

	faceSys.setEmotion("panic")

	dialogueSys.pool = data.screamBIG
	dialogueSys.speedMod = 1.3
	dialogueSys.send()
	await get_tree().create_timer(2).timeout
	faceSys.setEmotion("scared")
	await get_tree().create_timer(5).timeout
	faceSys.setEmotion("sad")
	await get_tree().create_timer(13).timeout
	faceSys.setEmotion("normal")

	shocked = false

func tempRagdoll() -> void:
	moveSys.ragdoll(false)
	ragdolled = true

	while true:
		await get_tree().create_timer(5.0).timeout
		if beingDragged or abs(moveSys.rigidtorso.linear_velocity.x) > 100.0:
			continue
		break

	moveSys.rigid.global_position.x = moveSys.rigidtorso.global_position.x
	moveSys.ragdoll(true)

	ragdolled = false
	await get_tree().create_timer(3).timeout

	if launchflag:
		dialogueSys.pool = data.getUp

	else:
		dialogueSys.pool = data.start
	dialogueSys.speedMod = 1.3
	dialogueSys.send()
	launchflag = true

func panicAttack():
	if moodSys.tick > -4.5 or moodSys.mood >= 20.0 or settings.lobotomize:
		return

	faceSys.setEmotion("sad")
	moveSys.dir = 1 if moveSys.rigid.global_position.x < float(GlobalVariable.screenWidth / 2) else -1

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

func passivetalk():
	while true:
		if !gbData.settings["mute"]:
			await get_tree().create_timer(randf_range(24.5, 55.5)).timeout
			dialogueSys.pool = data.passive
			dialogueSys.speedMod = 1.3
			dialogueSys.send()
		await get_tree().create_timer(.1).timeout
		print("no")

func wandering():
	while wander:
		await get_tree().create_timer(randi_range(4, 8)).timeout

		var center = GlobalVariable.screenWidth / 2.0
		var ex = moveSys.rigid.global_position.x
		var offset = ex - center
		var th = GlobalVariable.screenWidth * 0.25

		if offset > th:
			moveSys.dir = -1
		elif offset < -th:
			moveSys.dir = 1
		else:
			moveSys.dir = randi_range(-1, 1)

		await get_tree().create_timer(randf_range(.5, 2.0)).timeout
		moveSys.dir = 0
