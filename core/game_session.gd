extends HBoxContainer


onready var _board_container: VBoxContainer = $BoardContainer
onready var _session_settings: Panel = $SessionSettings


func _start_session() -> void:
	rpc("_show_board")


puppetsync func _show_board() -> void:
	_board_container.show()
	_session_settings.hide()
