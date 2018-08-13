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

    var moon_progress = get_node("Stats/Background/Container/MoonDistance/ProgressBar")
    moon_progress.value = (moon_state[0] / moon_state[1]) * 100
    moon_progress.get_node("Label").text = "%d / %d" % moon_state

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

    status.text = message
