extends CharacterBody2D

const BASE_SPEED = 150.0

var max_hp = 100
var current_hp = max_hp
var attack_damage = 10

var facing_direction = Vector2.DOWN

@onready var game_manager: Node = %GameManager
@onready var animated_sprite = $AnimatedSprite2D
@onready var attack_area = $AttackArea


func _ready():
	print(get_tree().get_nodes_in_group("player"))


func _physics_process(_delta: float) -> void:
	var current_speed = BASE_SPEED

	if game_manager.active_buffs_list.has(0):
		current_speed = BASE_SPEED + 100.0

	var direction := Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)

	if direction != Vector2.ZERO:
		velocity = direction * current_speed
		facing_direction = direction.normalized()
		update_animation(direction)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, current_speed)

	if Input.is_action_just_pressed("attack"):
		attack()

	move_and_slide()


func update_animation(dir: Vector2):
	if abs(dir.x) > abs(dir.y):
		if dir.x > 0:
			animated_sprite.play("walk_right")
		else:
			animated_sprite.play("walk_left")
	else:
		if dir.y > 0:
			animated_sprite.play("walk_down")
		else:
			animated_sprite.play("walk_up")


func attack():
	print("ATTACK START")

	attack_area.monitoring = true

	await get_tree().process_frame

	var bodies = attack_area.get_overlapping_bodies()
	print("HITS:", bodies)

	for body in bodies:
		if body.has_method("take_damage"):
			body.take_damage(attack_damage)
			print("HIT:", body.name)

	await get_tree().create_timer(0.1).timeout
	attack_area.monitoring = false

	print("ATTACK END")
