class_name SentenceLabel
extends RichTextLabel


signal substitution_index_changed(index)

var sentence: String setget set_sentence

var _words: Array


func set_sentence(new_sentence: String) -> void:
	sentence = new_sentence
	_words.clear()
	_redraw_text()
	emit_signal("substitution_index_changed", 0)


func set_words(words: Array) -> void:
	_words = words
	_redraw_text()


func add_word(word: String) -> void:
	_words.append(word)
	_redraw_text()
	emit_signal("substitution_index_changed", _words.size())


func remove_word(word: String) -> void:
	var index: int = _words.find(word)
	assert(index != -1, "Unable to remove word from sentence label: " + word)
	_words.remove(index)
	_redraw_text()
	emit_signal("substitution_index_changed", _words.size())


func _redraw_text() -> void:
	bbcode_text = sentence.format(_words, "...")
