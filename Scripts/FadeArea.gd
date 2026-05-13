extends Area2D

@export var HideAgain: bool = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var parent = self.get_parent()
		if parent:
			parent.modulate.a = 0
	

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		if HideAgain:
			var parent = self.get_parent()
			if parent:
				parent.modulate.a = 1
		else:
			return
