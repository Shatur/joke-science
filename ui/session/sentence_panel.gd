extends Panel


const SentenceButton: PackedScene = preload("res://ui/session/sentence_button.tscn")

onready var _sentence_label: SentenceLabel = $SentenceContainer/SentenceLabel
onready var _label_container: MarginContainer = $SentenceContainer
onready var _button_container: VBoxContainer = $VariantsContainer


func _ready():
	# warning-ignore:return_value_discarded
	GameState.connect("state_changed", self, "_on_state_changed")


func _on_state_changed(state: int) -> void:
	match state:
		GameState.ChoosingCards:
			_label_container.visible = true
			_button_container.visible = false
