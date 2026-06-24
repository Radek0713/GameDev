extends Node

@onready var coins_label: Label = %CoinsLabel
@onready var sword_label: Label = %SwordLabel
@onready var altars_label: Label = %AltarsLabel

var coins = 0
var sword_level = 0
var max_sword_level = 5

# --- NOWA LOGIKA OŁTARZY I TOTEMÓW ---
# Kolejka aktywnych ołtarzy (np. [0, 2] oznacza, że aktywna jest Szybkość i Obrażenia)
var active_buffs_list: Array = [] 

var available_altars = 1 # Maksymalny limit ołtarzy na raz (zaczynamy od 1, max 3)

# Lista zebranych unikalnych totemów (np. ["zimowy", "pustynny"])
var collected_totems: Array = [] 

func _ready() -> void:
	update_altars_ui()

func add_coin():
	coins += 1
	coins_label.text = "Coins: " + str(coins)

func activate_altar(buff_type: int):
	# Scenariusz A: Ołtarz jest już włączony -> Wyłączamy go
	if active_buffs_list.has(buff_type):
		active_buffs_list.erase(buff_type)
		#print("Wyłączono ołtarz typu: ", buff_type)
	
	# Scenariusz B: Ołtarz jest wyłączony -> Włączamy go (dodajemy na początek kolejki)
	else:
		active_buffs_list.push_front(buff_type)
		#print("Włączono ołtarz typu: ", buff_type, ". Aktualna kolejka: ", active_buffs_list)
		
		# Jeśli przekroczyliśmy aktualny limit dostępnych ołtarzy
		if active_buffs_list.size() > available_altars:
			var removed_buff = active_buffs_list.pop_back() # Usuwamy najstarszy z końca
			#print("Przekroczono limit! Wyłączono najstarszy ołtarz: ", removed_buff)

	# Aktualizujemy napisy na ekranie oraz wygląd ołtarzy w grze
	update_altars_ui()
	get_tree().call_group("altars", "update_visuals")

# NOWOŚĆ: Funkcja do podnoszenia totemów z potworów
func add_totem(totem_name: String):
	# Zabezpieczenie: Sprawdzamy czy gracz ma już ten konkretny totem
	if collected_totems.has(totem_name):
		#print("Masz już totem: ", totem_name, ". Nic się nie zmienia.")
		return # Przerywamy funkcję, nie dodajemy go po raz drugi
		
	# Jeśli to nowy totem, dodajemy go do listy
	collected_totems.append(totem_name)
	#print("Zdobyto nowy unikalny totem: ", totem_name, ". Suma totemów: ", collected_totems.size())
	
	# Twoja logika progów:
	if collected_totems.size() == 3:
		available_altars = 2
		#print("Odblokowano możliwość używania 2 ołtarzy na raz!")
	elif collected_totems.size() >= 4:
		available_altars = 3
		#print("Odblokowano możliwość używania 3 ołtarzy na raz!")
		
	update_altars_ui()

# Pomocnicza funkcja do odświeżania tekstu UI ołtarzy
func update_altars_ui():
	if altars_label:
		altars_label.text = "Altars: " + str(active_buffs_list.size()) + "/" + str(available_altars)

func add_sword_level():
	if sword_level < max_sword_level:
		sword_level += 1
		sword_label.text = "Sword: " + str(sword_level) + "/" + str(max_sword_level)
