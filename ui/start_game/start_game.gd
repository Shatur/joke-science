class_name StartGame
extends VBoxContainer


onready var _nickname_edit: LineEdit = $GridContainer/NicknameEdit
onready var _port_spinbox: SpinBox = $GridContainer/PortSpinBox
onready var _error_dialog: AcceptDialog = $ErrorDialog
onready var _confirm_button: Button = $ConfirmButton


func _ready() -> void:
	# warning-ignore:return_value_discarded
	GameState.connect("player_added", self, "_on_player_added")


func _confirm():
	pass


func _join_game() -> void:
	GameState.rpc("join_game", _nickname_edit.text)


func _on_player_added(player_state: PlayerState) -> void:
	# Wait for current player state initialization
	if (player_state == GameState.current_player_state):
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://ui/session/game_session.tscn")


func _on_nickname_changed(nickname: String) -> void:
	_confirm_button.disabled = nickname.empty()
