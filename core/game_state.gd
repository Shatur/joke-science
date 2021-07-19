extends Node


var player_states: Array


mastersync func add_player(nickname: String) -> void:
	var id: int = get_tree().multiplayer.get_rpc_sender_id()
	# Check if the id is already exists
	for player_state in player_states:
		if player_state.id == id:
			get_tree().network_peer.disconnect_peer(id, true)
		if player_state.nickname == nickname:
			nickname = nickname + " (" + String(id) + ")"

	player_states.append(PlayerState.new(id, nickname))
	print("Connected: ", nickname)
