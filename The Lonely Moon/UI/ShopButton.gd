extends Container

signal clicked;

var thing = {}

#    {
#		'id': 'cube_sat',
#		'display_name': 'CubeSat',
#		'description': 'Pretend that you\'re NASA, on the cheap.',
#		'type': 'satellite',
#		'cost': 500,
#		'build_time': 5,
#	},

func _ready():
    get_node("Background/Button").connect("pressed", self, "emit_signal", ["clicked"])
    get_node("Background/Cost").text = str(thing['cost']) + "btc"
    get_node("Background/Name").text = thing['display_name']
    get_node("Background/Button").hint_tooltip = thing['description']

func set_thing(x):
    thing = x