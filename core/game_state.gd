extends Node


signal player_added(player_state)

var player_states: Array


mastersync func add_player(nickname: String) -> void:
	var id: int = get_tree().multiplayer.get_rpc_sender_id()
	# Check if the id is already exists
	for player_state in player_states:
		if player_state.id == id:
			get_tree().network_peer.disconnect_peer(id, true)
		if player_state.nickname == nickname:
			nickname = nickname + " (" + String(id) + ")"

	var player_state := PlayerState.new(id, nickname)
	player_states.append(player_state)
	emit_signal("player_added", player_state)
	print("Connected: ", nickname)
