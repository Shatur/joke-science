class_name Chat
extends VBoxContainer


onready var _input_field: LineEdit = $InputField
onready var _chat_window: RichTextLabel = $Panel/ChatWindow


func _ready() -> void:
	# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_connected", self, "_announce_connected", [], CONNECT_DEFERRED)
	# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_disconnected", self, "_announce_disconnected")
	# warning-ignore:return_value_discarded
	get_tree().connect("server_disconnected", self, "_display_message", ["gray", "You have been disconnected from the server."])
	_display_message("gray", "You joined the game.")


master func _send_message(message: String) -> void:
	if message.empty():
		return
	var nickname: String = GameState.get_player_state(get_tree().get_rpc_sender_id()).nickname
	rpc("_display_message", "white", "[[color=green]%s[/color]]: %s" % [nickname, message])


puppetsync func _display_message(bbColor: String, message: String) -> void:
	_chat_window.bbcode_text += "\n%s [color=%s]%s[/color]" % [_time(), bbColor, message]


func _write_message(message: String) -> void:
	if message.empty():
		return
	_input_field.clear()
	rpc("_send_message", message)


func _announce_connected(id: int) -> void:
	var nickname: String = GameState.get_player_state(id).nickname
	_display_message("yellow", "%s has joined the game." % nickname)


func _announce_disconnected(id: int) -> void:
	var nickname: String = GameState.get_player_state(id).nickname
	_display_message("yellow", "%s has left the game." % nickname)


func _time() -> String:
	var time: Dictionary = OS.get_time()
	var time_string: String = "[%02d:%02d:%02d]" % [time.hour, time.minute, time.second]
	time_string = "[color=gray]" + time_string + "[/color]"
	return time_string
