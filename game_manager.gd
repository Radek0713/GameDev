extends Node

@onready var coins_label: Label = %CoinsLabel

var coins = 0

func add_coin():
	coins += 1
	coins_label.text = "Coins: " + str(coins)
