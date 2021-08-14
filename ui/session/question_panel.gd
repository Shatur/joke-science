extends Panel


const QuestionButton: PackedScene = preload("res://ui/session/question_button.tscn")

onready var _question_label: QuestionLabel = $LabelContainer/QuestionLabel

var question: Dictionary


func _ready():
	# warning-ignore:return_value_discarded
	GameState.connect("question_changed", self, "_set_question")


func _set_question(new_question: Dictionary) -> void:
	question = new_question
	_question_label.question = question["question"]
