class_name SentenceLabel
extends RichTextLabel


var _regex := RegEx.new()


func _init() -> void:
	# warning-ignore:return_value_discarded
	_regex.compile("\\{\\d\\}")


func format_sentence(sentence: String, subsitutions: Dictionary) -> void:
	bbcode_text = _regex.sub(sentence.format(subsitutions), "...", true)
