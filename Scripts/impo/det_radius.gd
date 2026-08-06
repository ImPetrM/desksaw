extends Node

var inRadius = {
	#object conainting itself and its metas
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_dect_body_entered(body: Node2D) -> void:
	if body.has_meta("object"):
		var metaKey = body.get_meta_list()
		var objData = {}
		for meta in metaKey:
			objData[meta] = body.get_meta(meta)
		inRadius.get_or_add(body,metaKey)
		print(inRadius)
		pass
	pass # Replace with function body.


func _on_dect_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
