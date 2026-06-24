extends Control

@onready var story_panel: Panel = $StoryPanel
@onready var controls_panel: Panel = $ControlsPanel
@onready var menu_buttons: VBoxContainer = $MenuButtons
@onready var main_menu_label: Label = $MainMenuLabel

func _ready() -> void:
	$MenuButtons/PlayButton.pressed.connect(_on_play_pressed)
	$MenuButtons/HowToPlayButton.pressed.connect(_on_how_to_play_pressed)
	$MenuButtons/ControlsButton.pressed.connect(_on_controls_pressed)
	$MenuButtons/ExitButton.pressed.connect(_on_exit_pressed)
	
	$StoryPanel/CloseStoryButton.pressed.connect(_on_close_panels_pressed)
	$ControlsPanel/CloseControlsButton.pressed.connect(_on_close_panels_pressed)

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")

func _on_how_to_play_pressed() -> void:
	menu_buttons.hide()
	main_menu_label.hide()
	story_panel.show()

func _on_controls_pressed() -> void:
	menu_buttons.hide()
	main_menu_label.hide()
	controls_panel.show()

func _on_close_panels_pressed() -> void:
	story_panel.hide()
	controls_panel.hide()
	menu_buttons.show()
	main_menu_label.show()

func _on_exit_pressed() -> void:
	get_tree().quit()
