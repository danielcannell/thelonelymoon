extends VBoxContainer

var status = null
var economy = null

func _ready():
    economy = get_node('../Economy')
    status = get_node('Stats/Background/Container/ScrollContainer/Stats')


func increment(dict, key, update=1):
    if not dict.has(key):
        dict[key] = 0
    dict[key] += update
    

func update_stats(delta, stats, debris_count, moon_state):
    var in_range = {}
    var up = {}
    var income = {}
    
    for sat in stats:
        increment(up, sat.type)
        increment(in_range, sat.type, 1 if sat.in_range() else 0)
        increment(income, sat.type, economy.ship_income(sat, stats) if sat.in_range() else 0)
        
    var fmt = """%s
        in space: %d
        operating: %d
        income: %d btc / second
"""
    var message = ""
    for m in global.MENU_CONFIG:
        if up.has(m.id):
            message += fmt % [m.display_name, up[m.id], in_range[m.id], income[m.id]]
    
    message += """Debris:
        in space: %d
""" % debris_count
        
    message += """Moon distance:
        %d units (from %d units)""" % moon_state

    status.text = message
