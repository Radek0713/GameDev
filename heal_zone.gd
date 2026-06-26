extends Area2D

@onready var game_manager = get_tree().get_first_node_in_group("game_manager")
@onready var heal_timer: Timer = $HealTimer

var player_inside: Node2D = null

func _ready() -> void:
	# Podłączamy sygnały wejścia/wyjścia gracza oraz zegara
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	heal_timer.timeout.connect(_on_heal_timer_timeout)
	
	# Ustawiamy czas zegara na podstawie zmiennej z GameManager
	if game_manager:
		heal_timer.wait_time = game_manager.heal_time

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_inside = body
		# Gracz wszedł do strefy, odpalamy zegar leczenia
		heal_timer.start()
		# Opcjonalnie: ulecz gracza od razu po wejściu w strefę
		_on_heal_timer_timeout()

func _on_body_exited(body: Node2D) -> void:
	if body == player_inside:
		player_inside = null
		# Gracz wyszedł, wyłączamy leczenie
		heal_timer.stop()

func _on_heal_timer_timeout() -> void:
	if player_inside:
		# Sprawdzamy, czy gracz potrzebuje leczenia
		if player_inside.current_hp < player_inside.max_hp:
			player_inside.current_hp += 1
			player_inside.update_hearts_ui()
		
		# Jeśli po uleczeniu gracz ma już max HP, możemy wyłączyć timer, żeby nie tykał na darmo
		if player_inside.current_hp >= player_inside.max_hp:
			heal_timer.stop()
