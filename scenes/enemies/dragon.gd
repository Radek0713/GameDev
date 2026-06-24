extends CharacterBody2D

const SPEED = 80.0
const AGGRO_RANGE = 400.0

var player = null

func _physics_process(delta):
	if player == null:
		player = get_tree().get_first_node_in_group("player")
		if player == null:
			return

	var to_player = player.global_position - global_position
	var distance = to_player.length()

	if distance < AGGRO_RANGE:
		velocity = to_player.normalized() * SPEED
	else:
		velocity = Vector2.ZERO

	move_and_slide()
