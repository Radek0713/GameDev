extends Area2D

@onready var game_manager = get_tree().get_first_node_in_group("game_manager")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		queue_free()
		game_manager.add_coin(1)
