extends BaseEnemy

func _ready() -> void:
	super()
	
	SPEED = 120.0       # szybciej
	AGGRO_RANGE = 300  # więcej
	max_hp = 26        # więcej
	damage = 1        # więcej
	attack_speed = 1.7
	current_hp = max_hp
