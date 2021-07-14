extends Node


var player_states: Array


mastersync func add_player(nickname: String) -> void:
	var player_state := PlayerState.new()
	player_state.nickname = nickname
	print("Connected: ", nickname)
