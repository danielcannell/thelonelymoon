extends MarginContainer

var curr_sat = null

func _ready():
    # Called when the node is added to the scene for the first time.
    # Initialization here
    pass

func lookup_sat_name(type):
    for e in global.MENU_CONFIG:
        if e['id'] == type:
            return e['display_name']

    return "UNKNOWN"

func _process(delta):
    # Called every frame. Delta is time since last frame.
    # Update game logic here.
    if curr_sat != null:
        var state = curr_sat.state()

        get_node("Background/C/Type/TypeVal").text = self.lookup_sat_name(state['type'])
        get_node("Background/C/Uptime/UptimeVal").text = "%.1fs" % state['uptime']
        var in_range_str = "no"
        if state['in_range']:
            in_range_str = "yes"
        get_node("Background/C/InRange/InRangeVal").text = in_range_str

func on_satellite_selected(sat):
    curr_sat = sat
    
    if curr_sat != null:
        self.visible = true
    else:
        self.visible = false