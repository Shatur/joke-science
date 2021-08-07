class_name PlayerState
extends Node


var id: int
var nickname: String
puppetsync var cards: Array


func _init(new_id: int, new_nickname: String) -> void:
	id = new_id
	nickname = new_nickname
