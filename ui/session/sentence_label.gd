class_name SentenceLabel
extends RichTextLabel


signal substitution_index_changed(index)

var sentence: String setget set_sentence

var _words: Dictionary


func set_sentence(new_sentence: String) -> void:
	sentence = new_sentence
	_words.clear()
	_redraw_text()
	emit_signal("substitution_index_changed", 0)


func add_word(word: String) -> void:
	var index: int = 0
	while _words.has(index):
		index += 1

	_words[index] = word
	_redraw_text()
	emit_signal("substitution_index_changed", _words.size())


func remove_word(word: String) -> void:
	var index = _words.get(word)
	assert(index != null, "Unable to remove word from sentence label: " + word)
	# warning-ignore:return_value_discarded
	_words.erase(index)
	_redraw_text()
	emit_signal("substitution_index_changed", _words.size())


func _redraw_text() -> void:
	bbcode_text = sentence.format(_words.values(), "...")
