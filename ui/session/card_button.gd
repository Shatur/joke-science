class_name CardButton
extends Button


var card: Dictionary

var _available_variants: PoolStringArray
var _variant_index: int

onready var label: Label = $Label

onready var _next_button: ToolButton = $NextButton
onready var _previous_button: ToolButton = $PreviousButton


func detect_available_words(case: String, number) -> void:
	_available_variants.resize(0)
	for variant in card:
		var parameters: Dictionary = card[variant]
		if parameters["cases"].has(case) and (number == null or parameters["numbers"].has(number)):
			_available_variants.append(variant)

	label.text = _available_variants[0]
	var disable_switch_buttons: bool = _available_variants.size() <= 1
	_next_button.disabled = disable_switch_buttons
	_previous_button.disabled = disable_switch_buttons


func _next_variant() -> void:
	_variant_index += 1
	if _variant_index == _available_variants.size():
		_variant_index = 0
	label.text = _available_variants[_variant_index]


func _previous_variant() -> void:
	_variant_index -= 1
	if _variant_index == -1:
		_variant_index = _available_variants.size() - 1
	label.text = _available_variants[_variant_index]
