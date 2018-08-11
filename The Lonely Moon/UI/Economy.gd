extends Node

var balance = 0

signal update_balance;

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func receive_state(delta, state):
	var income = 0
	for ship in state:
		if ship.in_range:
			var c = global.ship_config(ship.type)
			income += delta * c.income * exp(ship.uptime / c.time_constant)
	balance += income

	emit_signal("update_balance", balance)
