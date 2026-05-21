extends Node

@onready var coins_label: Label = %CoinsLabel

var coins = 0
var active_buff = -1 # 0 speed, 1 HP, 2 damage

func add_coin():
	coins += 1
	coins_label.text = "Coins: " + str(coins)

func activate_altar(buff_type: int):
	if active_buff == buff_type:
		active_buff = -1
	else:
		active_buff = buff_type # buff from altar
	get_tree().call_group("altars", "update_visuals")
