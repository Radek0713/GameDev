extends Area2D

@onready var game_manager = get_tree().get_first_node_in_group("game_manager")

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		queue_free()
		if game_manager and game_manager.has_method("add_relic"):
			game_manager.add_relic()
