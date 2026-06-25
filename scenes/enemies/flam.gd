extends BaseEnemy # Dziedziczymy po naszym nowym głównym skrypcie!

func _ready() -> void:
	super() # Wywołuje kod _ready() z BaseEnemy (ustawia HP i grupę)
	
	
	SPEED = 130.0       # 
	AGGRO_RANGE = 500
	max_hp = 1        # 
	damage = 3        # 
	current_hp = max_hp
