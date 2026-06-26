extends Node

@onready var coins_label: Label = %CoinsLabel
@onready var sword_label: Label = %SwordLabel
@onready var altars_label: Label = %AltarsLabel
@onready var totems_container: VBoxContainer = %TotemsContainer
@onready var relics_label: Label = %RelicsLabel

var coins = 0
var relics = 0
var sword_level = 0
var max_sword_level = 5

var active_buffs_list: Array = [] 
var available_altars = 0 # Max limit ołtarzy na raz (zaczynamy od 0, max 3)

var collected_totems: Array = [] 

var heal_time: float = 2 # Czas leczenia

func _ready() -> void:
	update_altars_ui()
	update_relics_ui()

func add_coin(n):
	coins += n
	update_coins_ui()

func update_coins_ui():
	if coins_label:
		coins_label.text = "Coins: " + str(coins)

	
func medic_collected() -> void:
	var player = get_tree().get_first_node_in_group("player")
	
	if player:
		player.current_hp = min(player.current_hp + 3, player.max_hp)
		
		if player.has_method("update_hearts_ui"):
			player.update_hearts_ui()

func activate_altar(buff_type: int):
	# Scenariusz A: Ołtarz jest już włączony -> Wyłączamy go
	if active_buffs_list.has(buff_type):
		active_buffs_list.erase(buff_type)
		
		# Wyłączamy efekty dezaktywowanego ołtarza
		match buff_type:
			0:
				deactivate_speed_altar()
			1:
				deactivate_hp_altar()
			2:
				deactivate_damage_altar()
	
	# Scenariusz B: Ołtarz jest wyłączony -> Włączamy go (dodajemy na początek kolejki)
	else:
		active_buffs_list.push_front(buff_type)
		
		# Włączamy efekty nowego ołtarza
		match buff_type:
			0:
				activate_speed_altar()
			1:
				activate_hp_altar()
			2:
				activate_damage_altar()
		
		# Jeśli przekroczyliśmy limit ołtarzy, usuwamy najstarszy z końca kolejki
		if active_buffs_list.size() > available_altars:
			var _removed_buff = active_buffs_list.pop_back() # Usuwamy najstarszy z końca
			
			# Bardzo ważne: Wyłączamy efekty ołtarza, który właśnie został wyrzucony z kolejki
			match _removed_buff:
				0:
					deactivate_speed_altar()
				1:
					deactivate_hp_altar()
				2:
					deactivate_damage_altar()

	# Aktualizujemy napisy na ekranie oraz wygląd ołtarzy w grze
	update_altars_ui()
	get_tree().call_group("altars", "update_visuals")

func add_totem(totem_name: String):
	#print("Added Totem")
	var lower_totem_name = totem_name.to_lower()
	if collected_totems.has(lower_totem_name):
		return
		
	collected_totems.append(lower_totem_name)
	
	if totems_container:
		var node_off_name = totem_name + "_Off"
		var node_on_name = totem_name + "_On"
		
		for totem_node in totems_container.get_children():
			if totem_node.name.to_lower() == node_off_name.to_lower():
				totem_node.hide()
				
			if totem_node.name.to_lower() == node_on_name.to_lower():
				totem_node.show()
	
	if collected_totems.size() == 2:
		available_altars = 1
	elif collected_totems.size() == 3:
		available_altars = 2
	elif collected_totems.size() >= 4:
		available_altars = 3
		
	update_altars_ui()
	
	# --- NOWOŚĆ: SPRAWDZENIE WARUNKU PRZYWOŁANIA BOSSA ---
	if collected_totems.size() >= 5:
		trigger_boss_spawn()

func trigger_boss_spawn() -> void:
	#print("GM: Zebrano 5 totemów! Próba przebudzenia bossa...")
	var boss = get_tree().get_first_node_in_group("boss")
	if boss and boss.has_method("awaken_boss"):
		boss.awaken_boss()
	#else:
		#print("GM BŁĄD: Nie znaleziono bossa w grupie 'boss' lub brakuje mu metody 'awaken_boss'!")

# Pomocnicza funkcja do odświeżania tekstu UI ołtarzy
func update_altars_ui():
	if altars_label:
		altars_label.text = "Altars: " + str(active_buffs_list.size()) + "/" + str(available_altars)

func add_sword_level():
	if sword_level < max_sword_level:
		sword_level += 1
		sword_label.text = "Sword: " + str(sword_level) + "/" + str(max_sword_level)

func add_relic() -> void:
	relics += 1
	update_relics_ui()

func update_relics_ui() -> void:
	if relics_label:
		relics_label.text = "Relics: " + str(relics)
		

# --- LOGIKA OŁTARZA SZYBKOŚCI ---
func activate_speed_altar() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player and "SPEED" in player:
		player.SPEED += 50.0

func deactivate_speed_altar() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player and "SPEED" in player:
		player.SPEED -= 50.0

# --- LOGIKA OŁTARZA DAMAGE ---
func activate_damage_altar() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player and "attack_damage" in player:
		player.attack_damage += 10

func deactivate_damage_altar() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player and "attack_damage" in player:
		player.attack_damage -= 10


# --- LOGIKA OŁTARZA HP ---
func activate_hp_altar() -> void:
	print("--- GM: Próba aktywacji ołtarza HP ---")
	
	var player = get_tree().get_first_node_in_group("player")
	
	if player == null:
		print("--- GM BŁĄD: Nie znaleziono obiektu w grupie 'player'! Sprawdź grupy gracza! ---")
		return
		
	print("--- GM: Znaleziono gracza! Stare max_hp = ", player.max_hp, " | Stare current_hp = ", player.current_hp)
	
	player.max_hp = 14
	player.current_hp = clampi(player.current_hp + 4, 0, 14)
	
	print("--- GM: Zmieniono w pamięci! Nowe max_hp = ", player.max_hp, " | Nowe current_hp = ", player.current_hp)
	
	if player.has_method("update_hearts_ui"):
		print("--- GM: Wywołuję update_hearts_ui() u gracza ---")
		player.update_hearts_ui()
	else:
		print("--- GM BŁĄD: Gracz nie ma funkcji 'update_hearts_ui'! ---")
func deactivate_hp_altar() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.max_hp = 10
		if player.current_hp > 10:
			player.current_hp = 10
			
		if player.has_method("update_hearts_ui"):
			player.update_hearts_ui()
		#print("GM: Wyłączono ołtarz HP. Gracz Max HP = ", player.max_hp)

func try_upgrade_sword() -> void:
	# 1. Sprawdzamy, czy miecz ma już maksymalny poziom
	if sword_level >= max_sword_level:
		#print("Miecz ma już maksymalny poziom!")
		return
		
	# 2. Sprawdzamy warunek finansowy (min 5 monet i 2 relikwie)
	if coins >= 10 and relics >= 2:
		coins -= 10
		relics -= 2
		
		update_coins_ui()
		update_relics_ui()
		#update_sword_ui() jednak nie robimy tej funkcji
		
		# Zwiększamy poziom miecza i odświeżamy jego napis na UI
		sword_level += 1
		sword_label.text = "Sword: " + str(sword_level) + "/" + str(max_sword_level)
		
		# 3. Zwiększamy obrażenia gracza
		var player = get_tree().get_first_node_in_group("player")
		if player and "attack_damage" in player:
			player.attack_damage += 5
			
