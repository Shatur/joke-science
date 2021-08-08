extends HBoxContainer


onready var _board_container: VBoxContainer = $BoardContainer
onready var _session_settings: Panel = $SessionSettings
onready var _error_dialog: AcceptDialog = $ErrorDialog
onready var _start_button: Button = $SessionSettings/MarginContainer/VBoxContainer/StartButton

func _ready() -> void:
	if not get_tree().is_network_server():
		_start_button.disabled = true

func _start_session() -> void:
	GameState.question_cards = _read_cards("res://cards/questions.json")
	if GameState.question_cards.empty():
		return

	GameState.answer_cards = _read_cards("res://cards/answers.json")
	if GameState.answer_cards.empty():
		return

	GameState.deal_cards()

	rpc("_show_board")


puppetsync func _show_board() -> void:
	_board_container.show()
	_session_settings.hide()


func _read_cards(filename: String) -> Array:
	var parser = CardParser.new()
	var parse_result: JSONParseResult = parser.open(filename)
	if parse_result.error != OK:
		_error_dialog.dialog_text = "Unable to open file"
		_error_dialog.popup_centered()
		return []

	return parse_result.result
