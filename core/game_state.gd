extends Node


signal player_added(player_state)
# warning-ignore:unused_signal
signal question_changed(question) # Called from RPC

const CARDS_COUNT: int = 10

var player_states: Array
var current_player_state: PlayerState

# Available only on server
var question_cards: Array
var answer_cards: Array

var _random := RandomNumberGenerator.new()


func _ready() -> void:
	_random.randomize()
	rpc_config("emit_signal", MultiplayerAPI.RPC_MODE_PUPPETSYNC)


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


func start_game() -> void:
	_deal_cards()
	_pick_question()


func _pick_question() -> void:
	var question_index: int = _random.randi_range(0, question_cards.size() - 1)
	rpc("emit_signal", "question_changed", question_cards[question_index])


func _deal_cards() -> void:
	for player_state in player_states:
		var cards: Array = []
		for _i in range(CARDS_COUNT):
			var card_index: int = _random.randi_range(0, answer_cards.size() - 1)
			cards.append(answer_cards[card_index])
		player_state.rpc_id(player_state.id, "set_cards", cards)


puppet func _acknowledge_player(id: int, nickname: String) -> void:
	var player_state := PlayerState.new(id, nickname)
	player_states.append(player_state)
	if get_tree().get_network_unique_id() == id:
		current_player_state = player_state # Store current player state for easy access
	add_child(player_state) # To allow RPC over network
	emit_signal("player_added", player_state)
