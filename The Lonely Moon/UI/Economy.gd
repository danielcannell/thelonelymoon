extends Node

var balance = 0

signal update_balance;

func _ready():
    # Called when the node is added to the scene for the first time.
    # Initialization here
    pass
    

func ship_income(uptime, type):
    var c = global.ship_config(type)
    return c.income * exp(uptime / c.time_constant)


func receive_state(delta, state):
    var income = 0
    for ship in state:
        if ship.in_range:
            income += delta * ship_income(ship.uptime, ship.type)
    balance += income

    emit_signal("update_balance", balance)


func make_fundraise(id):
    var f = global.FUNDRAISE_CONFIG[id]
    var displayname = "unknown"
    for m in global.MENU_CONFIG:
        if m['id'] == id:
            displayname = m["display_name"]

    var amt = rand_range(f.raised_min, f.raised_max)
    balance += amt
    emit_signal("update_balance", balance)
    get_node("..").create_notification("\"" + displayname + "\" complete! Earned " + str(floor(amt)) + " btc!")


func spend_money(amount):
    balance -= amount
