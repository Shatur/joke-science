class_name StartGame
extends VBoxContainer


onready var _nickname_edit: LineEdit = $GridContainer/NicknameEdit
onready var _port_spinbox: SpinBox = $GridContainer/PortSpinBox
onready var _error_dialog: AcceptDialog = $ErrorDialog
onready var _confirm_button: Button = $ConfirmButton


func _confirm():
	pass


func _enter_lobby() -> void:
	GameState.rpc("join_game", _nickname_edit.text)
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://core/game_session.tscn")


func _on_nickname_changed(nickname: String) -> void:
	_confirm_button.disabled = nickname.empty()
