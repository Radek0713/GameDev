extends CharacterBody2D

const SPEED = 100.0

# @onready ładuje odwołanie do animacji zaraz po uruchomieniu sceny.
# Upewnij się, że nazwa po znaku $ jest identyczna jak w drzewie sceny!
@onready var _animated_sprite = $AnimatedSprite2D

func _physics_process(_delta: float) -> void:
	# 1. Pobieranie wektora ruchu z klawiszy WSAD
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# 2. Obsługa ruchu
	if direction:
		velocity = direction * SPEED
		# Wywołujemy zmianę animacji tylko wtedy, gdy się poruszamy
		update_animation(direction)
	else:
		# Płynne hamowanie do zera
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)
		# UWAGA: Usunęliśmy stop(), więc animacja będzie trwać w miejscu

	# 3. Wykonanie fizyki ruchu
	move_and_slide()

func update_animation(dir: Vector2):
	# Sprawdzamy, która oś ruchu jest silniejsza, by wybrać kierunek
	if abs(dir.x) > abs(dir.y):
		# Ruch poziomy (lewo/prawo)
		if dir.x > 0:
			_animated_sprite.play("walk_right")
		else:
			_animated_sprite.play("walk_left")
	else:
		# Ruch pionowy (góra/dół)
		if dir.y > 0:
			_animated_sprite.play("walk_down")
		else:
			_animated_sprite.play("walk_up")
