class_name VariantsContainer
extends MarginContainer


const SentenceButtonScene: PackedScene = preload("res://ui/session/sentence_button.tscn")

onready var _vbox_container: VBoxContainer = $VBoxContainer


func _ready():
	# warning-ignore:return_value_discarded
	GameState.connect("state_changed", self, "_on_state_changed")


func _on_state_changed() -> void:
	match GameState.state:
		GameState.CHOOSING_CARDS:
			visible = false
		GameState.CHOOSING_SENTENCES:
			visible = true
			if get_tree().is_network_server():
				var substitutions: Array = []
				for player_state in GameState.player_states:
					substitutions.append(player_state.substitutions)
				rpc("_display_variants", substitutions)


puppetsync func _display_variants(substitutions: Array) -> void:
	visible = true
	var current_sentence: String = GameState.current_sentence["text"]
	for substitution in substitutions:
		var sentence_button: SentenceButton = SentenceButtonScene.instance()
		_vbox_container.add_child(sentence_button)
		sentence_button.sentence_label.format_sentence(current_sentence, substitution)
