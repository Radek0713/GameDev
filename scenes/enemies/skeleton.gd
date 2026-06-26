extends BaseEnemy # Dziedziczymy po naszym nowym głównym skrypcie!

func _ready() -> void:
	super() # Wywołuje kod _ready() z BaseEnemy (ustawia HP i grupę)
	
	
	#SPEED = 80.0       # bazowo
	#AGGRO_RANGE = 400
	max_hp = 70        # bardzo dużo
	damage = 1        # mało
	attack_speed = 2.2
	current_hp = max_hp
