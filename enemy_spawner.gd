extends Node

@export var skeleton_scene: PackedScene # Zimowy
@export var lizard_scene: PackedScene   # Dżungla
@export var cyclop_scene: PackedScene   # Suchy biom
@export var dragon_scene: PackedScene   # Polana biom
@export var flame_scene: PackedScene    # Wymarły biom

# Referencje do folderów-węzłów wewnątrz Game/Enemies/
@onready var skeletons_container: Node = get_node("/root/Game/Enemies/Skeletons")
@onready var dragons_container: Node = get_node("/root/Game/Enemies/Dragons")
@onready var lizards_container: Node = get_node("/root/Game/Enemies/Lizards")
@onready var cyclops_container: Node = get_node("/root/Game/Enemies/Cyclops")
@onready var flames_container: Node = get_node("/root/Game/Enemies/Flames")

@onready var spawn_timer: Timer = $SpawnTimer

# Struktura danych przechowująca informacje o każdym biomie
var biomes: Array = []

func _ready() -> void:
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	
	# DEFINICJA BIOMÓW (Możesz tu ręcznie edytować koordynaty i promienie)
	biomes = [
		{
			"name": "Zimowy",
			"center": Vector2(700, 3800),
			"radius": 1000.0,
			"scene": skeleton_scene,
			"container": skeletons_container
		},
		{
			"name": "Dzungla",
			"center": Vector2(1500, 500),
			"radius": 600.0,
			"scene": lizard_scene,
			"container": lizards_container
		},
		{
			"name": "Suchy",
			"center": Vector2(6300, 3600),
			"radius": 1100.0,
			"scene": cyclop_scene,
			"container": cyclops_container
		},
		{
			"name": "Polana",
			"center": Vector2(6500, -700),
			"radius": 1300.0,
			"scene": dragon_scene,
			"container": dragons_container
		},
		{
			"name": "Wymarly",
			"center": Vector2(2800, 2000),
			"radius": 1000.0,
			"scene": flame_scene,
			"container": flames_container
		}
	]

func _on_spawn_timer_timeout() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if not player:
		return # Jeśli gracz nie żyje lub go nie ma, nie spawnujemy
		
	var player_pos = player.global_position
	
	# Pętla sprawdza KAŻDY biom niezależnie, co x sekund
	for biome in biomes:
		var distance_to_biome = player_pos.distance_to(biome["center"])
		
		if distance_to_biome <= 4500.0:
			if randf() <= 0.2:
				spawn_enemy_in_biome(biome)

func spawn_enemy_in_biome(biome: Dictionary) -> void:
	if biome["scene"] == null:
		#print("Ostrzeżenie: Brak przypisanej sceny potwora dla biomu: ", biome["name"])
		return
		
	var player = get_tree().get_first_node_in_group("player")
	if not player:
		return
		
	# 1. Losowanie punktu wewnątrz okręgu biomu
	var random_angle = randf() * TAU
	var random_radius = randf() * biome["radius"]
	var offset = Vector2(cos(random_angle), sin(random_angle)) * random_radius
	var spawn_position = biome["center"] + offset
	
	# 2. WARUNEK 1: Czy punkt jest zbyt blisko gracza (mniej niż x kratek)?
	if spawn_position.distance_to(player.global_position) < 500.0:
		return # Przerywamy spawn, punkt jest za blisko gracza
		
	# 3. WARUNEK 2: Czy w tym punkcie znajduje się przeszkoda (np. Solid z TileMapLayer)?
	if is_point_colliding(spawn_position):
		return # Przerywamy spawn, w tym miejscu stoi przeszkoda
	
	var enemy_instance = biome["scene"].instantiate() as Node2D
	enemy_instance.global_position = spawn_position
	
	# Sprawdzamy, czy dedykowany węzeł-folder istnieje
	if biome["container"] != null:
		biome["container"].add_child(enemy_instance)
	else:
		# Awaryjny zapis w głównym węźle, jeśli ścieżka była błędna
		get_parent().add_child(enemy_instance)

# POMOCNICZA FUNKCJA: Sprawdzanie kolizji fizycznej w konkretnym punkcie
func is_point_colliding(point: Vector2) -> bool:
	var space_state = get_viewport().get_world_2d().direct_space_state
	
	# Tworzymy zapytanie punktowe dla fizyki 2D
	var query = PhysicsPointQueryParameters2D.new()
	query.position = point
	
	# --- USTALENIE WARSTWY KOLIZJI (COLLISION MASK) ---
	# Musimy powiedzieć silnikowi, jakich warstw ma szukać.
	# Jeśli Twoje przeszkody (Solid/TileMapLayer) stoją np. na Warstwie 1 (World / Ściany),
	# ustawiamy maskę na 1. Możesz też zaznaczyć kilka warstw za pomocą kodu binarnego.
	query.collision_mask = 1 # Szuka obiektów blokujących na warstwie 1
	
	# Wykonujemy test. Jeśli tablica nie jest pusta, oznacza to, że punkt w coś uderzył.
	var result = space_state.intersect_point(query)
	return result.size() > 0
