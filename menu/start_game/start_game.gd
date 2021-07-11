class_name StartGame
extends VBoxContainer


onready var _port_spinbox: SpinBox = $GridContainer/PortSpinBox
onready var _error_dialog: AcceptDialog = $ErrorDialog


func _confirm():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://core/board.tscn")
