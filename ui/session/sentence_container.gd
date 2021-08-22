extends MarginContainer


onready var _sentence_label: SentenceLabel = $SentenceLabel


func _ready():
	# warning-ignore:return_value_discarded
	GameState.connect("new_sentence_available", self, "set_visible", [true])
	# warning-ignore:return_value_discarded
	GameState.connect("all_cards_choosen", self, "_on_all_cards_choosen")
	# warning-ignore:return_value_discarded
	GameState.current_player_state.connect("next_substitution_changed", self, "_redraw_text")


# TODO 4.0: unbind index
func _redraw_text(_index: int) -> void:
	_sentence_label.format_sentence(GameState.current_sentence["text"], GameState.current_player_state.substitutions)


# TODO 4.0: unbind substitutions
func _on_all_cards_choosen(_substitutions: Array) -> void:
	visible = false
