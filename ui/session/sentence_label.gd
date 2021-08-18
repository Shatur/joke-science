class_name SentenceLabel
extends RichTextLabel


signal substitution_index_changed(index)

var sentence: String setget set_sentence

var _regex := RegEx.new()
var _words: Dictionary


func _init() -> void:
	# warning-ignore:return_value_discarded
	_regex.compile("\\{\\d\\}")


func set_sentence(new_sentence: String) -> void:
	sentence = new_sentence
	_words.clear()
	_redraw_text()
	emit_signal("substitution_index_changed", 0)


func add_word(word: String) -> void:
	var index: int = _first_missing_index()
	_words[index] = word
	_redraw_text()
	emit_signal("substitution_index_changed", _first_missing_index(index))


func remove_word(word: String) -> void:
	var remove_index: int = -1
	for index in _words:
		if _words[index] == word:
			remove_index = index
	
	assert(remove_index != -1, "Unable to remove word from sentence label: " + word)
	# warning-ignore:return_value_discarded
	_words.erase(remove_index)
	_redraw_text()
	emit_signal("substitution_index_changed", _first_missing_index())


func _redraw_text() -> void:
	bbcode_text = _regex.sub(sentence.format(_words), "...", true)


func _first_missing_index(begin: int = 0) -> int:
	for index in range(begin, _words.size()):
		if not _words.has(index):
			return index
	return _words.size()
