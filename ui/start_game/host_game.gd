extends StartGame


onready var _max_players: SpinBox = $GridContainer/PlayerCountSpinBox


func _confirm() -> void:
	var peer = NetworkedMultiplayerENet.new()
	if peer.create_server(_port_spinbox.value, _max_players.value) != OK:
		_error_dialog.dialog_text = "Unable to create server"
		_error_dialog.popup_centered()
		return

	get_tree().network_peer = peer
	_join_game()
