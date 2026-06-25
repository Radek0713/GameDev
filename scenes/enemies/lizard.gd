extends BaseEnemy

func _ready() -> void:
	super()
	
	
	SPEED = 140.0       # szybciej
	AGGRO_RANGE = 300  # więcej
	max_hp = 40        # więcej
	damage = 1        # więcej
	current_hp = max_hp
