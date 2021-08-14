extends Button


onready var _question_button: QuestionLabel = $MarginContainer/QuestionLabel


func set_words(words: Array) -> void:
	_question_button.set_words(words)
