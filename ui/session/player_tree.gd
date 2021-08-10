extends Tree


func _ready() -> void:
	# warning-ignore:return_value_discarded
	create_item()

	for player_state in GameState.player_states:
		_display_player(player_state)

	# warning-ignore:return_value_discarded
	GameState.connect("player_added", self, "_display_player")


func _display_player(player_state: PlayerState) -> void:
	var player_item: TreeItem = create_item(get_root())
	player_item.set_text(0, player_state.nickname)
