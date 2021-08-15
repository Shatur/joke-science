class_name CardButton
extends Button


var card: Dictionary

var _available_variants: PoolStringArray
var _variant_index: int

onready var _label: Label = $Label
onready var _next_button: ToolButton = $NextButton
onready var _previous_button: ToolButton = $PreviousButton


func _ready() -> void:
	# warning-ignore:return_value_discarded
	GameState.connect("state_changed", self, "_on_game_state_changed")


func _on_game_state_changed(state: int) -> void:
	match state:
		GameState.ChoosingCards:
			disabled = false
			_detect_available_words()
		GameState.ChoosingSentence:
			disabled = true


func _detect_available_words() -> void:
	_available_variants.resize(0)
	for substitution in GameState.current_sentence["substitutions"]:
		var case: String = substitution["case"]
		var number = substitution.get("number")
		for variant in card:
			var parameters: Dictionary = card[variant]
			if parameters["cases"].has(case) and (number == null or parameters["numbers"].has(number)):
				_available_variants.append(variant)

	_label.text = _available_variants[0]
	var disable_switch_buttons: bool = _available_variants.size() <= 1
	_next_button.disabled = disable_switch_buttons
	_previous_button.disabled = disable_switch_buttons


func _next_variant() -> void:
	_variant_index += 1
	if _variant_index == _available_variants.size():
		_variant_index = 0
	_label.text = _available_variants[_variant_index]


func _previous_variant() -> void:
	_variant_index -= 1
	if _variant_index == -1:
		_variant_index = _available_variants.size() - 1
	_label.text = _available_variants[_variant_index]
