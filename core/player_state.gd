class_name PlayerState
extends Node

signal card_added(card)
signal substitutions_count_changed(count)
signal next_substitution_changed(index)


var id: int
var nickname: String
var substitutions: Dictionary

var _cards: Array setget set_cards


func _init(new_id: int, new_nickname: String) -> void:
	id = new_id
	nickname = new_nickname
	GameState.connect("state_changed", self, "_on_game_state_changed")


mastersync func add_word(word: String) -> void:
	var index: int = _first_missing_index()
	if get_tree().is_network_server():
		if not _validate_word(word, GameState.current_sentence["substitutions"][index]):
			get_tree().network_peer.disconnect_peer(get_tree().get_rpc_sender_id())
	substitutions[index] = word
	emit_signal("substitutions_count_changed", substitutions.size())
	emit_signal("next_substitution_changed", _first_missing_index(index))


mastersync func remove_word(word: String) -> void:
	var remove_index: int = -1
	for index in substitutions:
		if substitutions[index] == word:
			remove_index = index
	
	assert(remove_index != -1, "Unable to remove word from sentence: " + word)
	# warning-ignore:return_value_discarded
	substitutions.erase(remove_index)
	emit_signal("substitutions_count_changed", substitutions.size())
	emit_signal("next_substitution_changed", _first_missing_index())


puppetsync func set_cards(cards: Array) -> void:
	_cards = cards
	for card in _cards:
		emit_signal("card_added", card)


func _on_game_state_changed(state: int) -> void:
	match state:
		GameState.ChoosingCards:
			substitutions.clear()
			emit_signal("substitutions_count_changed", 0)
			emit_signal("next_substitution_changed", 0)


func _validate_word(word: String, substitution: Dictionary) -> bool:
	var case: String = substitution["case"]
	var number = substitution.get("number")
	for card in _cards:
		var parameters = card.get(word)
		if parameters == null:
			continue
		if parameters["cases"].has(case) and (number == null or not parameters["numbers"].has(number)):
			return true
		return false
	return false


func _first_missing_index(begin: int = 0) -> int:
	for index in range(begin, substitutions.size()):
		if not substitutions.has(index):
			return index
	return substitutions.size()
