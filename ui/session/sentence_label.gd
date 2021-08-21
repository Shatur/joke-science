class_name SentenceLabel
extends RichTextLabel


var _regex := RegEx.new()


func _init() -> void:
	# warning-ignore:return_value_discarded
	_regex.compile("\\{\\d\\}")


func _ready() -> void:
	# warning-ignore:return_value_discarded
	GameState.current_player_state.connect("next_substitution_changed", self, "_redraw_text")


# TODO 4.0: unbind index
func _redraw_text(_index: int) -> void:
	bbcode_text = _regex.sub(GameState.current_sentence["text"].format(GameState.current_player_state.substitutions), "...", true)
