extends Node
@export var skeleton: Skeleton2D
@export var rigid: RigidBody2D
@export var rigidtorso: RigidBody2D
@export var animplay: AnimationPlayer
@export var eyes: Sprite2D
@export var tail: Bone2D
var flip = false
var backwards = false
var dir: float = -0.1
var new_texture = preload("res://assets/Body/experimentEyeSad.png")
var friction: float = 30.0
var speedacc: float = 20.0
var maxspeed: float = 351.0 # you will understand what the one is for later
#i literally forgot what the one was for
var notragdolled = true
enum states {
	moving, idle, ragdoll
}
var currstate = states.idle
func _ready() -> void:
	animplay.play("idleagain")
	pass
func _physics_process(delta: float) -> void:
	dir = Input.get_axis("testl", "testr")

	if dir != 0.0:
		initswithc(states.moving)
	else:
		initswithc(states.idle)
	
	phystate()

	if abs(rigid.linear_velocity.x) > maxspeed + 520:
		bully()
	pass


func initswithc(state: states):
	if currstate == state: return
	currstate = state
	match state:
		states.idle:
			animplay.speed_scale = 1
			animplay.play("idleagain")
			pass

	pass

func phystate():
	match currstate:
		states.idle:
			rigid.linear_velocity.x = move_toward(rigid.linear_velocity.x, 0, friction)

			pass
		states.moving:
			var tempmax = maxspeed
			#apply movement based on direction
			if backwards:
				tempmax = tempmax / 2
			if abs(rigid.linear_velocity.x) < tempmax:
				rigid.apply_central_force(Vector2(dir, 0) * speedacc)

		
			var normlized = abs(remap(rigid.linear_velocity.x, 0, maxspeed, 0.0, 1.0))
			#there used to be a long if statement here and my ass got flamed when i posted it
			backwards = checkpositive(dir) == flip
			var target_anim = "moveB" if backwards else "moveF"

			if animplay.current_animation != target_anim:
				animplay.play(target_anim)

			animplay.speed_scale = (normlized / 2) + .2
			#print(clamp(rigid.linear_velocity.x, -maxspeed, maxspeed))
			pass

func bully():
	ragdoll(false)
	await get_tree().create_timer(4).timeout


func detFlip():
	#determine when you gotta FLIPPPP
	pass

func ragdoll(val: bool):
	if val == notragdolled: return
	notragdolled = val
	
	var descendants = skeleton.find_children("*", "", true, false)
	var moredesc = rigid.find_children("*", "", true, false)
	eyes.texture = new_texture
	for child in descendants:
		if child is RemoteTransform2D:
			var rtt: RemoteTransform2D = child
			rtt.update_position = val
			rtt.update_rotation = val

	for child in moredesc:
		if child is RigidBody2D:
			child.freeze = val
			if val == false:
				child.linear_velocity = rigid.linear_velocity
				child.angular_velocity = rigid.angular_velocity
	if val: # fix the weird bug with teleporting
		print(rigidtorso.global_position)
		rigid.global_position = rigidtorso.global_position + Vector2(100, -20)

"""
literally useless function that i added because i saw that older games source code had helper functions for everything because
they had it way harder than i did and i want to larp
"""
func checkpositive(num):
	if num is int:
		if num >= 0:
			return true
		else:
			return false
			
	if num is float:
		if num >= 0:
			return true
		else:
			return false
