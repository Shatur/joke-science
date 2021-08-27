extends StartGame


onready var _ip_label: LineEdit = $GridContainer/IpLineEdit
onready var _connection_dialog: ConnectionDialog = $ConnectionDialog


func _confirm() -> void:
	var peer = NetworkedMultiplayerENet.new()
	if peer.create_client(_ip_label.text, _port_spinbox.value) != OK:
		_error_dialog.dialog_text = "Unable to join server"
		_error_dialog.popup_centered()
		return
	
	get_tree().network_peer = peer
	_connection_dialog.show_connecting(_ip_label.text, _port_spinbox.value)
	# warning-ignore:return_value_discarded
	_connection_dialog.connect("canceled", peer, "close_connection")
	# warning-ignore:return_value_discarded
	peer.connect("connection_succeeded", self, "_on_connection_succeed")
	# warning-ignore:return_value_discarded
	peer.connect("connection_failed", self, "_on_connection_failed")


func _on_connection_succeed() -> void:
	_join_game()


func _on_connection_failed() -> void:
	get_tree().network_peer = null
	_error_dialog.dialog_text = "Connection failed"
	_connection_dialog.hide()
	_error_dialog.popup_centered()
