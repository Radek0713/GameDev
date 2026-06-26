extends CharacterBody2D
class_name BaseEnemy

@export var SPEED: float = 80.0
@export var AGGRO_RANGE: float = 600.0
@export var max_hp: int = 30
@export var damage: int = 1 # Zmieniamy domyślnie na 1 HP, zgodnie z planem
@export var attack_speed: float = 1.0 # Czas w sekundach między atakami (np. 2.0 = 2 sekundy)

var current_hp: int
var player: CharacterBody2D = null
var is_player_in_attack_range: bool = false

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_area: Area2D = $AttackArea
@onready var attack_timer: Timer = $Timer


# --- NOWE STATYSTYKI DROPÓW ---
@export_group("Drop Rates")
@export_range(0.0, 1.0) var relic_drop_chance: float = 0.10
@export_range(0.0, 1.0) var totem_drop_chance: float = 0.05
@export var my_totem_name: String = "Ice" # Nazwa totemu przypisana do tego moba
@export var money_bag_scene: PackedScene = preload("res://scenes/items/coins_bag.tscn")
@export_range(0.0, 1.0) var moneybag_drop_chance: float = 0.10
# Ścieżki do scen przedmiotów, które mają się pojawić na ziemi
# Upewnij się, że ścieżka do Twojej apteczki/monety jest poprawna, lub podmień je na dedykowane sceny Relicu/Totemu
@export var relic_scene: PackedScene = preload("res://scenes/items/relic.tscn")

func _ready() -> void:
	current_hp = max_hp
	add_to_group("enemies")
	
	# Podłączamy sygnały wejścia/wyjścia gracza ze strefy ataku moba
	attack_area.body_entered.connect(_on_attack_area_body_entered)
	attack_area.body_exited.connect(_on_attack_area_body_exited)
	
	# Podłączamy cykliczne odliczanie timera
	attack_timer.timeout.connect(_on_attack_timer_timeout)

func _physics_process(_delta: float) -> void:
	if player == null:
		player = get_tree().get_first_node_in_group("player") as CharacterBody2D
		if player == null:
			return

	# Jeśli gracz jest w zasięgu ataku, potwór zatrzymuje się i bije
	if is_player_in_attack_range:
		velocity = Vector2.ZERO
	else:
		# Standardowy pościg (Twój dotychczasowy kod)
		var to_player = player.global_position - global_position
		var distance = to_player.length()

		if distance < AGGRO_RANGE:
			velocity = to_player.normalized() * SPEED
			update_enemy_animation(velocity)
		else:
			velocity = Vector2.ZERO
			if sprite:
				sprite.stop()

	move_and_slide()

func update_enemy_animation(dir: Vector2) -> void:
	if sprite == null: return
	if abs(dir.x) > abs(dir.y):
		if dir.x > 0: sprite.play("walk_right")
		else: sprite.play("walk_left")
	else:
		if dir.y > 0: sprite.play("walk_down")
		else: sprite.play("walk_up")

func take_damage(amount: int) -> void:
	current_hp -= amount
	if current_hp <= 0:
		check_drops()
		queue_free()

# NOWA FUNKCJA: Losowanie i tworzenie przedmiotów na mapie
func check_drops() -> void:
	# 1. LOSOWANIE RELIC (Wyrzuca fizyczny przedmiot na ziemię)
	if randf() <= relic_drop_chance:
		if relic_scene:
			var spawned_relic = relic_scene.instantiate() as Node2D
			spawned_relic.global_position = global_position
			get_parent().add_child(spawned_relic)

	# 2. LOSOWANIE TOTEMU
	if randf() <= totem_drop_chance:
		var game_manager = get_tree().get_first_node_in_group("game_manager")
		if game_manager and game_manager.has_method("add_totem"):
			game_manager.add_totem(my_totem_name)
	
	# 3. LOSOWANIE MONEYBAG
	if randf() <= moneybag_drop_chance:
		if money_bag_scene:
			var spawned_bag = money_bag_scene.instantiate() as Node2D
			spawned_bag.global_position = global_position
			get_parent().add_child(spawned_bag)

# Wykrycie, że gracz podszedł pod cios
func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_player_in_attack_range = true
		
		if is_inside_tree() and attack_timer and attack_timer.is_stopped():
			attack_timer.start(attack_speed)

# Wykrycie, że gracz uciekł ze strefy ciosu
func _on_attack_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_player_in_attack_range = false
		if attack_timer:
			attack_timer.stop()

# Funkcja wykonująca uderzenie w gracza
func hit_player() -> void:
	if player && player.has_method("take_damage"):
		player.take_damage(damage)

# Wywoływane co X sekund przez Timer, jeśli gracz ciągle stoi obok moba
func _on_attack_timer_timeout() -> void:
	if is_player_in_attack_range:
		hit_player() # Potwór zadaje obrażenia dopiero TERAZ!
		
		if is_inside_tree() and attack_timer:
			attack_timer.start(attack_speed)
	else:
		if attack_timer:
			attack_timer.stop()
