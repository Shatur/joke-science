extends Node


signal player_added(player_state)

var player_states: Array


master func join_game(nickname: String) -> void:
	var id: int = get_tree().multiplayer.get_rpc_sender_id()
	# Check if the id is already exists
	for player_state in player_states:
		if player_state.id == id:
			get_tree().network_peer.disconnect_peer(id, true)
		if player_state.nickname == nickname:
			nickname = nickname + " (" + String(id) + ")"

	# Send all other players to just connected player
	for player_state in player_states:
		rpc_id(id, "_acknowledge_player", player_state.id, player_state.nickname)

	_acknowledge_player(id, nickname)
	rpc("_acknowledge_player", id, nickname)


puppet func _acknowledge_player(id: int, nickname: String) -> void:
	var player_state := PlayerState.new(id, nickname)
	player_states.append(player_state)
	emit_signal("player_added", player_state)
