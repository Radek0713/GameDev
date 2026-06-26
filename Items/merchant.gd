extends Area2D

@onready var game_manager = get_tree().get_first_node_in_group("game_manager")
var is_player_near: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_player_near = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_player_near = false

func _process(_delta: float) -> void:
	if is_player_near and Input.is_action_just_pressed("interact"):
		if game_manager and game_manager.has_method("try_upgrade_sword"):
			game_manager.try_upgrade_sword()
