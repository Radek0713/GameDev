extends CharacterBody2D

const BASE_SPEED = 150.0 # Zmieniliśmy nazwę na BASE_SPEED, by łatwiej dodawać bonusy

var max_hp = 100
var current_hp = max_hp
var attack_damage = 10
# Ładujemy odwołanie do GameManager za pomocą Scene Unique Node (%)
@onready var game_manager: Node = %GameManager
@onready var _animated_sprite = $AnimatedSprite2D

# Zaktualizuj sekcję obsługi prędkości wewnątrz _physics_process:
func _physics_process(_delta: float) -> void:
	var current_speed = BASE_SPEED
	
	# NOWOŚĆ: Sprawdzamy, czy 0 (Szybkość) znajduje się na liście aktywnych ołtarzy
	if game_manager.active_buffs_list.has(0):
		current_speed = BASE_SPEED + 100.0
	
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if direction:
		velocity = direction * current_speed
		update_animation(direction)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, current_speed)

	move_and_slide()

func update_animation(dir: Vector2):
	if abs(dir.x) > abs(dir.y):
		if dir.x > 0:
			_animated_sprite.play("walk_right")
		else:
			_animated_sprite.play("walk_left")
	else:
		if dir.y > 0:
			_animated_sprite.play("walk_down")
		else:
			_animated_sprite.play("walk_up")
