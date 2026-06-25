extends Control

func _ready() -> void:
	$ButtonsContainer/MainMenuButton.pressed.connect(_on_main_menu_pressed)
	$ButtonsContainer/ExitButton.pressed.connect(_on_exit_pressed)

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
