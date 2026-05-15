extends Node2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.get("jumpPadHeight"):
		body.velocity.y = body.jumpPadHeight
		$Sprite2D/AnimationPlayer.play("activate")
