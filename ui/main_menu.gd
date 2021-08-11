extends Control


var _current_window: Control

onready var _main_menu: VBoxContainer = $MainMenu
onready var _back_button: Button = $BackButton


func _open(menu_name: String) -> void:
	_current_window = get_node(menu_name)
	_main_menu.hide()
	_current_window.show()
	_back_button.show()


func _back() -> void:
	_back_button.hide()
	_main_menu.show()
	_current_window.hide()


func _exit():
	get_tree().quit()
