extends Node2D


const PLAYER = preload("uid://caygih315h4mq")

func _ready():
	var new_player = PLAYER.instantiate()
	add_child(new_player)
