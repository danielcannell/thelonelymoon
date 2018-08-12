extends Node

var balance = 0

signal update_balance;

func _ready():
    # Called when the node is added to the scene for the first time.
    # Initialization here
    pass
    

static func ship_income(uptime, type):
    var c = global.ship_config(type)
    if c == null:
        return 0
    
    if uptime < c.time_constant:
        return c.income
    
    return lerp(c.income, 0.25 * c.income, (uptime - c.time_constant) / (4 * c.time_constant))

func receive_state(delta, state):
    var income = 0
    for ship in state:
        if ship.in_range:
            income += delta * ship_income(ship.uptime, ship.type)
    balance += income

    emit_signal("update_balance", balance)


func make_fundraise(id):
    var f = global.FUNDRAISE_CONFIG[id]
    var displayname = global.id_display_lookup[id]

    var amt = rand_range(f.raised_min, f.raised_max)
    balance += amt
    emit_signal("update_balance", balance)
    get_node("..").create_notification("\"" + displayname + "\" complete! Earned " + str(floor(amt)) + " btc!", global.NOTIFICATION_TYPE.INFO)


func spend_money(amount):
    balance -= amount
