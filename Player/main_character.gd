extends CharacterBody2D

var SPEED: float = 280.0
var max_hp = 10
var current_hp = 10
var attack_damage = 21
var can_attack: bool = true
var attack_cooldown_time: float = 1.0

var facing_direction = Vector2.DOWN

@onready var game_manager: Node = %GameManager
@onready var animated_sprite = $AnimatedSprite2D
@onready var attack_area = $AttackArea
@onready var hearts_container: HBoxContainer = %HBoxContainer 
@onready var attack_cooldown_timer: Timer = $AttackCooldownTimer


func _ready() -> void:
	add_to_group("player")


func _physics_process(_delta: float) -> void:

	var direction := Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)

	if direction != Vector2.ZERO:
		velocity = direction * SPEED
		facing_direction = direction.normalized()
		update_animation(direction)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)

	move_and_slide()
	
	if Input.is_action_just_pressed("attack") and can_attack:
		attack()
		


func update_animation(dir: Vector2):
	if abs(dir.x) > abs(dir.y):
		if dir.x > 0:
			animated_sprite.play("walk_right")
		else:
			animated_sprite.play("walk_left")
	else:
		if dir.y > 0:
			animated_sprite.play("walk_down")
		else:
			animated_sprite.play("walk_up")


func attack() -> void:
	can_attack = false
	
	var overlapping_bodies = attack_area.get_overlapping_bodies()
	
	for body in overlapping_bodies:
		if body.is_in_group("enemies") and body.has_method("take_damage"):
			body.take_damage(attack_damage)
			
	attack_cooldown_timer.start(attack_cooldown_time)

func _on_attack_cooldown_timer_timeout() -> void:
	can_attack = true
			

func take_damage(amount: int) -> void:
	current_hp -= amount
	update_hearts_ui()
	
	if current_hp <= 0:
		get_tree().call_deferred("change_scene_to_file","res://scenes/death_screen.tscn")

func update_hearts_ui() -> void:
	if hearts_container == null:
		return
		
	var hearts = hearts_container.get_children()
	
	for i in range(hearts.size()):
		if i < max_hp:
			if i < current_hp:
				hearts[i].show()
			else:
				hearts[i].hide() 
		else:
			hearts[i].hide()
