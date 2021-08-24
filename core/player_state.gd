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
	# warning-ignore:return_value_discarded
	GameState.connect("state_changed", self, "_on_state_changed")


mastersync func add_word(word: String) -> void:
	var index: int = _first_missing_index()
	if get_tree().is_network_server():
		if not _validate_state(word):
			return
		if not _validate_next_index(word, index):
			return
		if not _validate_substitution(word, GameState.current_sentence["substitutions"][index]):
			return
	substitutions[index] = word
	emit_signal("substitutions_count_changed", substitutions.size())
	emit_signal("next_substitution_changed", _first_missing_index(index))


mastersync func remove_word(word: String) -> void:
	var remove_index: int = -1
	for index in substitutions:
		if substitutions[index] == word:
			remove_index = index
	
	if get_tree().is_network_server():
		if not _validate_state(word):
			return
		if not _validate_index(word, remove_index):
			return

	# warning-ignore:return_value_discarded
	substitutions.erase(remove_index)
	emit_signal("substitutions_count_changed", substitutions.size())
	emit_signal("next_substitution_changed", _first_missing_index())


puppet func set_cards(cards: Array) -> void:
	_cards = cards
	for card in _cards:
		emit_signal("card_added", card)


func _on_state_changed() -> void:
	if GameState.state == GameState.CHOOSING_CARDS:
		substitutions.clear()
		emit_signal("substitutions_count_changed", 0)
		emit_signal("next_substitution_changed", 0)


func _validate_substitution(word: String, substitution: Dictionary) -> bool:
	var case: String = substitution["case"]
	var number = substitution.get("number")
	for card in _cards:
		var parameters = card.get(word)
		if parameters == null:
			continue
		if parameters["cases"].has(case) and (number == null or parameters["numbers"].has(number)):
			return true
		GameState.disconnect_cheater(get_tree().get_rpc_sender_id(), "The word %s cannot be substituted" % word)
		return false
	GameState.disconnect_cheater(get_tree().get_rpc_sender_id(), "Unable to find word %s in player cards" % word)
	return false


func _validate_next_index(word: String, index: int) -> bool:
	if index < GameState.current_sentence["substitutions"].size():
		return true
	GameState.disconnect_cheater(get_tree().get_rpc_sender_id(), "Received word %s when the number of substitutions in the sentence has ended" % word)
	return false


func _validate_index(word: String, index: int) -> bool:
	if index != -1:
		return true
	GameState.disconnect_cheater(get_tree().get_rpc_sender_id(), "Unable to find index for word: %s" % word)
	return false


func _validate_state(word: String) -> bool:
	if GameState.state == GameState.CHOOSING_CARDS:
		return true
	GameState.disconnect_cheater(get_tree().get_rpc_sender_id(), "Received word %s when current state is not choosing cards" % word)
	return false


func _first_missing_index(begin: int = 0) -> int:
	for index in range(begin, substitutions.size()):
		if not substitutions.has(index):
			return index
	return substitutions.size()
