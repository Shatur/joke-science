class_name PlayerState
extends Node

signal card_added(card)


var id: int
var nickname: String

var _cards: Array setget set_cards


func _init(new_id: int, new_nickname: String) -> void:
	id = new_id
	nickname = new_nickname


puppetsync func set_cards(cards: Array) -> void:
	_cards = cards
	for card in _cards:
		emit_signal("card_added", card)
