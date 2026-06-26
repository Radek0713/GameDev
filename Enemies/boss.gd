extends BaseEnemy

# Flaga kontrolująca, czy boss został już aktywowany przez totemy
var is_awakened: bool = false

func _ready() -> void:
	# Wywołujemy _ready() z klasy BaseEnemy, aby podłączyć sygnały i timery
	super()
	
	# POTĘŻNE STATYSTYKI BOSSA
	SPEED = 20.0             # Boss jest wolniejszy, ale groźniejszy
	AGGRO_RANGE = 300.0      # Widzi gracza z bardzo daleka
	max_hp = 500             # Ogromny pasek zdrowia
	current_hp = max_hp
	damage = 4               # Zabiera aż 3 HP jednym ciosem
	attack_speed = 2       # Atakuje rzadziej, ale potężnie
	
	
	# Na starcie wyłączamy proces fizyki, żeby boss nie gonił gracza będąc niewidzialnym
	set_physics_process(false)

# Nowa funkcja wywoływana przez GameManager, gdy gracz zbierze 5 totemów
func awaken_boss() -> void:
	is_awakened = true
	show() # Pokazujemy bossa na mapie
	set_physics_process(true) # Włączamy mu sztuczną inteligencję (AI) i ruch
	#print("BOSS SIĘ OBUDZIŁ!")
