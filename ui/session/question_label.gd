class_name QuestionLabel
extends RichTextLabel


var question: String setget set_question

var _words: Array


func set_question(new_question: String) -> void:
	question = new_question
	_redraw_text()


func set_words(words: Array) -> void:
	_words = words
	_redraw_text()


func add_word(word: String) -> void:
	_words.append(word)
	_redraw_text()


func remove_word(word: String) -> void:
	var index: int = _words.find(word)
	assert(index != -1, "Unable to remove word from question label: " + word)
	_words.remove(index)
	_redraw_text()


func _redraw_text() -> void:
	bbcode_text = question.format(_words, "...")
