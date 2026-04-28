extends Area2D

@export var connectedRoom: String

@export var playerPos: Vector2
@export var playerJumpOnEnter: bool = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		RoomChangeGlobal.activate = true
		RoomChangeGlobal.playerPos = playerPos
		RoomChangeGlobal.playerJumpOnEnter = playerJumpOnEnter
		get_tree().call_deferred("change_scene_to_file", connectedRoom)
	pass # Replace with function body.
