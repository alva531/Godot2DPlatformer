@tool
extends Area2D
class_name RoomZoneArea2D

@export var zoom: Vector2 = Vector2.ONE

@export var follow_player: bool = false
@export var fixed_position: Vector2 = Vector2.ZERO

@export var limit_camera: bool = false
@export var limit_left: float = -10000
@export var limit_top: float = -10000
@export var limit_right: float = 10000
@export var limit_bottom: float = 10000

var collisionshape: CollisionShape2D
var cam_node: Camera2D

func _ready() -> void:
	collisionshape = get_child(0)
	monitorable = false
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
func _notification(what):
	if what == NOTIFICATION_EDITOR_PRE_SAVE:
		_update_limits_from_collision()
		
func _update_limits_from_collision() -> void:
	if !collisionshape:
		collisionshape = get_child(0) as CollisionShape2D
	
	if !collisionshape:
		return

	if !collisionshape.shape:
		return

	if collisionshape.shape is RectangleShape2D:
		var rect_shape := collisionshape.shape as RectangleShape2D
		
		var extents = rect_shape.size * 0.5
		var global_pos = collisionshape.global_position

		limit_left = global_pos.x - extents.x
		limit_right = global_pos.x + extents.x
		limit_top = global_pos.y - extents.y
		limit_bottom = global_pos.y + extents.y

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if !cam_node:
			cam_node = get_tree().get_first_node_in_group("RoomZoneCamera")
		cam_node.overlapping_zones.append(self)
		
func _on_body_exited(body:Node2D) -> void:
	if body.is_in_group("player"):
		if !cam_node:
			cam_node = get_tree().get_first_node_in_group("RoomZoneCamera")
		cam_node.overlapping_zones.erase(self)
