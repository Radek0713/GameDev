extends BaseEnemy

# Flaga kontrolująca, czy boss został już aktywowany przez totemy
var is_awakened: bool = false

func _ready() -> void:
	super()
	
	SPEED = 40.0             
	AGGRO_RANGE = 300.0      
	max_hp = 100             
	current_hp = max_hp
	damage = 4               
	attack_speed = 2       
	
	set_physics_process(false)
	
	$CollisionShape2D.set_deferred("disabled", true)
	
	# Wyłącza kolizję strefy ataku, żeby boss nie bił gracza będąc ukrytym
	if has_node("AttackArea/CollisionShape2D"):
		$AttackArea/CollisionShape2D.set_deferred("disabled", true)

# Nowa funkcja wywoływana przez GameManager, gdy gracz zbierze 5 totemów
func awaken_boss() -> void:
	is_awakened = true
	show() # Pokazujemy bossa wizualnie
	set_physics_process(true) # Włączamy mu ruch i AI
	
	$CollisionShape2D.set_deferred("disabled", false)
	
	if has_node("AttackArea/CollisionShape2D"):
		$AttackArea/CollisionShape2D.set_deferred("disabled", false)

# Nadpisujemy funkcję take_damage z klasy BaseEnemy, żeby sprawdzić specyficzny warunek śmierci bossa
func take_damage(amount: int) -> void:
	current_hp -= amount
	if current_hp <= 0:
		show_win_screen()
		queue_free()

func show_win_screen() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/win_screen.tscn")
