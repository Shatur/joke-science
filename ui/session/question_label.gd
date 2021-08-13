extends RichTextLabel


var question: String setget set_question
var words: Array


func set_question(new_question: String) -> void:
	question = new_question
	_redraw_text()


func add_word(word: String) -> void:
	words.append(word)
	_redraw_text()


func remove_word(word: String) -> void:
	var index: int = words.find(word)
	assert(index != -1, "Unable to remove word from question label: " + word)
	words.remove(index)
	_redraw_text()


func _redraw_text() -> void:
	bbcode_text = question % words
