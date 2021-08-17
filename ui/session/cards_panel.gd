extends Panel


signal word_choosen(word)

const CardButtonScene: PackedScene = preload("res://ui/session/card_button.tscn")

onready var _grid_container: GridContainer = $MarginContainer/GridContainer


func _ready():
	# warning-ignore:return_value_discarded
	GameState.current_player_state.connect("card_added", self, "_add_card")


func redraw_cards(substitution_index: int) -> void:
	var substitutions: Array = GameState.current_sentence["substitutions"]
	if substitutions.size() == substitution_index:
		_disable_all_cards()
	else:
		_detect_available_words(substitutions[substitution_index])


func _disable_all_cards() -> void:
	for card_button in _grid_container.get_children():
		card_button.disabled = true


func _detect_available_words(substitution: Dictionary) -> void:
	var case: String = substitution["case"]
	var number = substitution.get("number")
	for card_button in _grid_container.get_children():
		card_button.detect_available_words(case, number)


func _add_card(card: Dictionary) -> void:
	var card_button: CardButton = CardButtonScene.instance()
	_grid_container.add_child(card_button)
	card_button.card = card
	# warning-ignore:return_value_discarded
	card_button.connect("pressed", self, "_on_card_selected", [card_button])


func _on_card_selected(card_button: CardButton) -> void:
	emit_signal("word_choosen", card_button.label.text)
