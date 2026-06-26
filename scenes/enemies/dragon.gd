extends BaseEnemy # Dziedziczymy po naszym nowym głównym skrypcie!

func _ready() -> void:
	super() # Wywołuje kod _ready() z BaseEnemy (ustawia HP i grupę)
	
	
	#SPEED = 80.0       # bazowo
	AGGRO_RANGE = 800  # więcej
	max_hp = 40        # więcej
	damage = 2        # więcej
	attack_speed = 2.7
	current_hp = max_hp
