extends BaseEnemy # Dziedziczymy po naszym nowym głównym skrypcie!

func _ready() -> void:
	super() # Wywołuje kod _ready() z BaseEnemy (ustawia HP i grupę)
	
	SPEED = 60.0       # wolny
	#AGGRO_RANGE = 400
	max_hp = 50        # dużo
	damage = 1        # mało
	attack_speed = 2
	current_hp = max_hp
