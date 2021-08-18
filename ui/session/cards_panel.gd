extends Panel


signal word_added(word)
signal word_removed(word)

const CardButtonScene: PackedScene = preload("res://ui/session/card_button.tscn")

onready var _grid_container: GridContainer = $MarginContainer/GridContainer


func _ready():
	# warning-ignore:return_value_discarded
	GameState.current_player_state.connect("card_added", self, "_add_card")


func redraw_cards(substitution_index: int) -> void:
	var substitutions: Array = GameState.current_sentence["substitutions"]
	if substitutions.size() == substitution_index:
		_disable_unpressed_cards()
	else:
		_detect_available_words(substitutions[substitution_index])


func _disable_unpressed_cards() -> void:
	for card_button in _grid_container.get_children():
		if not card_button.pressed:
			card_button.disabled = true


func _detect_available_words(substitution: Dictionary) -> void:
	var case: String = substitution["case"]
	var number = substitution.get("number")
	for card_button in _grid_container.get_children():
		if not card_button.pressed:
			card_button.detect_available_words(case, number)
			card_button.disabled = false


func _add_card(card: Dictionary) -> void:
	var card_button: CardButton = CardButtonScene.instance()
	_grid_container.add_child(card_button)
	card_button.card = card
	# warning-ignore:return_value_discarded
	card_button.connect("toggled", self, "_on_card_toggled", [card_button])


func _on_card_toggled(button_pressed: bool, card_button: CardButton) -> void:
	if button_pressed:
		emit_signal("word_added", card_button.label.text)
	else:
		emit_signal("word_removed", card_button.label.text)
