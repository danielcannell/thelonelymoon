extends MarginContainer

var Economy = preload('res://UI/Economy.gd')
var curr_sat = null


func lookup_sat_name(type):
    return global.id_display_lookup[type]


func _process(delta):
    # Called every frame. Delta is time since last frame.
    # Update game logic here.
    if curr_sat != null:
        var state = curr_sat.state()
        var satellites = get_node("/root/Node/Playfield").get_satellites()
        var constellation_size = global.constellation_size(satellites, curr_sat.type)

        get_node("Background/C/Type/TypeVal").text = self.lookup_sat_name(state['type'])
        get_node("Background/C/Uptime/UptimeVal").text = "%.1fs" % state['uptime']
        var in_range_str = "no"
        if state['in_range']:
            in_range_str = "yes"
        get_node("Background/C/InRange/InRangeVal").text = in_range_str
        get_node("Background/C/Deltav/PrgBar/Text").text = "%.1f" % state['delta_v']
        get_node("Background/C/Deltav/PrgBar").value = (state['delta_v'] / state['delta_v_max']) * 100
        var income = Economy.ship_income(curr_sat, satellites) if state['in_range'] else 0.0
        get_node("Background/C/Income/IncomeVal").text = "%.1f btc/s" % income
        get_node("Background/C/Constellation/ConstellVal").text = "%s" % constellation_size


func on_satellite_selected(sat):
    curr_sat = sat
    
    if curr_sat != null:
        self.visible = true
    else:
        self.visible = false
