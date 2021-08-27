extends Node


signal player_added(player_state)
signal cheating_detected(id, reason)
signal state_changed()

enum {
	NO_STATE,
	CHOOSING_CARDS,
	CHOOSING_SENTENCES,
}

const CARDS_COUNT: int = 10

puppetsync var current_sentence: Dictionary
var player_states: Array
var current_player_state: PlayerState

# Available only on server
var sentence_cards: Array
var answer_cards: Array
var state: int = NO_STATE setget set_state

var _random := RandomNumberGenerator.new()


func _ready() -> void:
	_random.randomize()


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

	rpc("_acknowledge_player", id, nickname)


func start_game() -> void:
	_deal_cards()
	_pick_sentence()


func get_player_state(id: int) -> PlayerState:
	for player_state in player_states:
		if player_state.id == id:
			return player_state
	return null


func disconnect_cheater(id: int, reason: String) -> void:
	emit_signal("cheating_detected", id, reason)
	get_tree().network_peer.disconnect_peer(id)


puppet func set_state(new_state: int) -> void:
	state = new_state
	emit_signal("state_changed")
	if get_tree().is_network_server():
		rpc("set_state", state)


func _pick_sentence() -> void:
	var sentence_index: int = _random.randi_range(0, sentence_cards.size() - 1)
	rset("current_sentence", sentence_cards[sentence_index])
	# TODO 4.0: remove self
	self.state = CHOOSING_CARDS


func _deal_cards() -> void:
	for player_state in player_states:
		var cards: Array = []
		for _i in range(CARDS_COUNT):
			var card_index: int = _random.randi_range(0, answer_cards.size() - 1)
			cards.append(answer_cards[card_index])
		if player_state.id != get_tree().get_network_unique_id():
			player_state.rpc_id(player_state.id, "set_cards", cards)
		player_state.set_cards(cards)


puppetsync func _acknowledge_player(id: int, nickname: String) -> void:
	var player_state := PlayerState.new(id, nickname)
	player_states.append(player_state)
	if get_tree().get_network_unique_id() == id:
		current_player_state = player_state # Store current player state for easy access
	if get_tree().is_network_server():
		# warning-ignore:return_value_discarded
		player_state.connect("substitutions_count_changed", self, "_check_cards_choosen")
	add_child(player_state, true) # To allow RPC over network
	emit_signal("player_added", player_state)


# TODO 4.0: Unbind count
func _check_cards_choosen(_count: int) -> void:
	var subsitutions_count: int = current_sentence["substitutions"].size()
	for player_state in player_states:
		if player_state.substitutions.size() != subsitutions_count:
			return

	# TODO 4.0: remove self
	self.state = CHOOSING_SENTENCES
