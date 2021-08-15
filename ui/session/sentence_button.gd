extends Button


onready var _sentence_button: SentenceLabel = $MarginContainer/SentenceLabel


func set_words(words: Array) -> void:
	_sentence_button.set_words(words)
