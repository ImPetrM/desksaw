extends RapierRigidBody2D
@export
var skeletonRef: Skeleton2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if abs(linear_velocity.length()) > 900:
		rtEnable(false)
		pass
	pass

func rtEnable(val: bool):
	var descendants = skeletonRef.find_children("*", "", true, false)

	for child in descendants:
		if child is RemoteTransform2D:
			var rtt: RemoteTransform2D = child

			print(child.name)
			rtt.update_position = val
			rtt.update_rotation = val
