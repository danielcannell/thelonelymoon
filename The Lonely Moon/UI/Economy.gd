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


func make_fundraise(id):
    var f = global.FUNDRAISE_CONFIG[id]
    var amt = rand_range(f.raised_min, f.raised_max)
    balance += amt
    emit_signal("update_balance", balance)
    get_node("..").create_notification("Campaign complete! Earned " + str(floor(amt)) + " btc!")


func spend_money(amount):
    balance -= amount
