extends StartGame


onready var _ip_label: LineEdit = $GridContainer/IpLineEdit


func _confirm() -> void:
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(_ip_label.text, _port_spinbox.value)
	get_tree().network_peer = peer

	._confirm()
