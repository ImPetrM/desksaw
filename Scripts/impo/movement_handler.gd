extends Node
@export var skeleton: Skeleton2D
@export var rigid: RigidBody2D
@export var rigidtorso: RigidBody2D
@export var animplay: AnimationPlayer
@export var eyes: Sprite2D
@export var tail: Bone2D
@export var skelparent: Node2D
@export var headIk: Node2D
@export var headIkControl: SoupLookAt


@export var ragdollspeed: float = 610.0

signal sigragdoll()
var lookback = false
var flip = false
var backwards = false
var dir: float = 0.0
var wander = true
var friction: float = 30.0
var speedacc: float = 20.0
var maxspeed: float = 280.0 # you will understand what the one is for later
#i literally forgot what the one was for
var notragdolled = true

@export var defheadnose: Node2D

enum states {
	moving, idle, ragdoll
}
var currstate = states.idle
func _ready() -> void:
	animplay.play("idleagain")
	#randomdir()
	pass
func _physics_process(delta: float) -> void:
	if dir != 0.0:
		initswithc(states.moving)
	else:
		initswithc(states.idle)
	
	phystate(delta)


	detFlip()
	headIKf()
	
	pass

func headIKf():
	var dirx: float = sign(rigid.get_global_mouse_position().x - rigid.global_position.x)
	var facing: float = -1.0 if flip else 1.0

	var mouse_pos: Vector2 = headIk.get_global_mouse_position()
	var dist: float = rigid.global_position.distance_to(headIk.get_global_mouse_position())

	if dist <= 300.0:
		lookback = dirx != facing
		if dirx != facing:
			mouse_pos.x = rigid.global_position.x - (mouse_pos.x - rigid.global_position.x)
			mouse_pos.y = (rigid.global_position.y - 300) - (mouse_pos.y - rigid.global_position.y)

		headIk.global_position = headIk.global_position.lerp(mouse_pos, .05)
	else:
		lookback = false
		headIk.global_position = headIk.global_position.lerp(defheadnose.global_position, .05)

func initswithc(state: states):
	if currstate == state: return
	currstate = state
	match state:
		states.idle:
			animplay.speed_scale = 1
			animplay.play("idleagain")
			pass

	pass

func phystate(delta: float):
	match currstate:
		states.idle:
			rigid.linear_velocity.x = move_toward(rigid.linear_velocity.x, 0, friction)

			pass
		states.moving:
			var tempmax = maxspeed
			#apply movement based on direction
			if backwards:
				tempmax = (tempmax / 2) + 40
			var moving_same_direction = sign(rigid.linear_velocity.x) == dir

			if !moving_same_direction or abs(rigid.linear_velocity.x) < tempmax:
				rigid.apply_central_force(Vector2(dir, 0) * speedacc)

		
			var normlized = abs(remap(rigid.linear_velocity.x, 0, maxspeed, 0.0, 1.0))
			#there used to be a long if statement here and my ass got flamed when i posted it
			backwards = checkpositive(dir) == flip
			var target_anim = "moveB" if backwards else "moveF"

			if animplay.current_animation != target_anim:
				animplay.play(target_anim)

			animplay.speed_scale = (normlized / 2) + .1
			
			#print(clamp(rigid.linear_velocity.x, -maxspeed, maxspeed))
			pass


func detFlip():
	var dirx: float = sign(rigid.get_global_mouse_position().x - rigid.global_position.x)
	var facing: float = -1.0 if flip else 1.0

		
	if dirx == dir:
		if dir != 0:
			skelparent.scale.x = dir
		if dir == 1:
			flip = false
		else:
			flip = true


		pass
	#determine when you gotta FLIPPPP
	pass

func ragdoll(val: bool):
	if val == notragdolled: return
	notragdolled = val
	
	var descendants = skeleton.find_children("*", "", true, false)
	var moredesc = rigid.find_children("*", "", true, false)

	for child in descendants:
		if child is RemoteTransform2D:
			var rtt: RemoteTransform2D = child
			rtt.update_position = val
			rtt.update_rotation = val
			rtt.update_scale = val

	for child in moredesc:
		if child is RigidBody2D:
			child.freeze = val
			if val == false:
				child.linear_velocity = rigid.linear_velocity
				child.angular_velocity = rigid.angular_velocity
	if !val:
		GlobalVariable.ragaa()
	if val: # fix the weird bug with teleporting
		print(rigidtorso.global_position)
		rigid.global_position = rigidtorso.global_position + Vector2(100, -10)

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


func randomdir():
	while wander:
		await get_tree().create_timer(randi_range(4, 8)).timeout
		dir = randi_range(-1, 1)
		await get_tree().create_timer(randf_range(.5, 2.0)).timeout
		dir = 0
