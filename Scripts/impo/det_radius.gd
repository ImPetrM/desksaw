extends Node

var inRadius = {
	#object conainting itself and its metas
}

var mousePriority = 5
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_dect_body_entered(body: Node2D) -> void:
	if body.has_meta("object"):
		var metaKeys = body.get_meta_list()
		var objData = {}
		

		for meta in metaKeys:
			objData[meta] = body.get_meta(meta)
		

		inRadius[body] = objData
		print(inRadius)

func _on_dect_body_exited(body: Node2D) -> void:
	if inRadius.has(body):
		inRadius.erase(body)
		print(body.name, " curr", inRadius)
