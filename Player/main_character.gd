extends CharacterBody2D

const BASE_SPEED = 150.0 # Zmieniliśmy nazwę na BASE_SPEED, by łatwiej dodawać bonusy

# Ładujemy odwołanie do GameManager za pomocą Scene Unique Node (%)
@onready var game_manager: Node = %GameManager
@onready var _animated_sprite = $AnimatedSprite2D

func _physics_process(_delta: float) -> void:
	# Domyślnie ustawiamy prędkość na bazową
	var current_speed = BASE_SPEED
	
	# Jeśli w GameManagerze aktywny jest buff o numerze 0 (Szybkość), zwiększamy prędkość
	if game_manager.active_buff == 0:
		current_speed = BASE_SPEED + 100.0 # Postać będzie biegać z prędkością 350
	
	# 1. Pobieranie wektora ruchu z klawiszy WSAD
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# 2. Obsługa ruchu z uwzględnieniem aktualnej prędkości
	if direction:
		velocity = direction * current_speed
		update_animation(direction)
	else:
		# Płynne hamowanie do zera z użyciem odpowiedniej prędkości
		velocity = velocity.move_toward(Vector2.ZERO, current_speed)

	# 3. Wykonanie fizyki ruchu
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
