extends MarginContainer


onready var _sentence_label: SentenceLabel = $SentenceLabel


func _ready():
	# warning-ignore:return_value_discarded
	GameState.connect("state_changed", self, "_on_state_changed")
	# warning-ignore:return_value_discarded
	GameState.current_player_state.connect("next_substitution_changed", self, "_redraw_text")


# TODO 4.0: unbind index
func _redraw_text(_index: int) -> void:
	_sentence_label.format_sentence(GameState.current_sentence["text"], GameState.current_player_state.substitutions)


func _on_state_changed() -> void:
	match GameState.state:
		GameState.CHOOSING_CARDS:
			visible = true
		GameState.CHOOSING_SENTENCES:
			visible = false
