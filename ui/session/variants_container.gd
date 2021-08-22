class_name VariantsContainer
extends MarginContainer


const SentenceButtonScene: PackedScene = preload("res://ui/session/sentence_button.tscn")

onready var _vbox_container: VBoxContainer = $VBoxContainer


func _ready():
	# warning-ignore:return_value_discarded
	GameState.connect("new_sentence_available", self, "set_visible", [false])
	# warning-ignore:return_value_discarded
	GameState.connect("all_cards_choosen", self, "_display_variants")


func _display_variants(substitutions: Array) -> void:
	visible = true
	var current_sentence: String = GameState.current_sentence["text"]
	for substitution in substitutions:
		var sentence_button: SentenceButton = SentenceButtonScene.instance()
		_vbox_container.add_child(sentence_button)
		sentence_button.sentence_label.format_sentence(current_sentence, substitution)
