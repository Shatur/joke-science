extends StartGame


onready var _ip_label: LineEdit = $GridContainer/IpLineEdit


func _confirm() -> void:
	var peer = NetworkedMultiplayerENet.new()
	if peer.create_client(_ip_label.text, _port_spinbox.value) != OK:
		_error_dialog.dialog_text = "Unable to join server"
		_error_dialog.popup_centered()
		return
	
	get_tree().network_peer = peer
	._confirm()
