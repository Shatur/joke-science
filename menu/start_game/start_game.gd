class_name StartGame
extends VBoxContainer


onready var _nickname_edit: LineEdit = $GridContainer/NicknameEdit
onready var _port_spinbox: SpinBox = $GridContainer/PortSpinBox
onready var _error_dialog: AcceptDialog = $ErrorDialog


func _confirm():
	GameState.rpc_id(0, "add_player", _nickname_edit.text)
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://core/board.tscn")
