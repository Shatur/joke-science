extends Panel


const CardButtonScene: PackedScene = preload("res://ui/session/card_button.tscn")

onready var _grid_container: GridContainer = $MarginContainer/GridContainer


func _ready():
	# warning-ignore:return_value_discarded
	GameState.current_player_state.connect("card_added", self, "_add_card")


func _add_card(card: Dictionary) -> void:
	var card_button: CardButton = CardButtonScene.instance()
	_grid_container.add_child(card_button)
	card_button.card = card
