extends HBoxContainer


func _ready() -> void:
	# warning-ignore:return_value_discarded
	get_tree().network_peer.connect("peer_connected", self, "_on_peer_connected")


func _on_peer_connected(id: int) -> void:
	print("Connected: ", str(id))
