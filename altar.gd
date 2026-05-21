extends Area2D

# Pozwala w Inspektorze wybrać typ ołtarza (0 = Szybkość, 1 = HP, 2 = Obrażenia)
@export_enum("Szybkość", "HP", "Obrażenia") var buff_type: int = 0

@onready var game_manager: Node = %GameManager
var is_player_near = false

func _ready() -> void:
	# Podłączamy sygnały wykrywania obiektów
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	# Ustawiamy wygląd po załadowaniu mapy
	update_visuals()

func _on_body_entered(body: Node2D) -> void:
	# Sprawdzamy, czy obiekt, który wszedł, posiada nasz skrypt gracza
	if body is CharacterBody2D:
		is_player_near = true

func _on_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		is_player_near = false

func _process(_delta: float) -> void:
	# Jeśli gracz stoi blisko i wciśnie 'E'
	if is_player_near and Input.is_action_just_pressed("interact"):
		game_manager.activate_altar(buff_type)

# Aktualizuje wygląd ołtarza na podstawie danych z GameManager
func update_visuals() -> void:
	if game_manager.active_buff == buff_type:
		$SpriteOn.show()
		# SpriteOff zostaje zawsze włączony, zgodnie z Twoim planem
	else:
		$SpriteOn.hide()
