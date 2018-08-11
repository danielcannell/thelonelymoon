extends Node

func _ready():
	pass

const SHIP_CONFIG = [
	{
		'name': 'cube_sat',
		'display_name': 'CubeSat',
		'description': 'Pretend that you\'re NASA, on the cheap.',
	 	'alt_min': 350,
	 	'alt_max': 380,
	 	'delta_v': 50,
		'cost': 500,
		'income': 10,
	},
	{
		'name': 'spy_satellite',
		'display_name': 'Spy Satellite',
		'description': 'Keep an eye on the neighbours.',
	 	'alt_min': 500,
	 	'alt_max': 520,
	 	'delta_v': 100,
		'cost': 1000,
		'income': 25,
	},
	{
		'name': 'science_station',
		'display_name': 'Science Station',
		'description': 'We\'re doing science and we\'re still alive',
	 	'alt_min': 600,
	 	'alt_max': 700,
	 	'delta_v': 150,
		'cost': 10000,
		'income': 100,
	},
	{
		'name': 'space_hotel',
		'display_name': 'Space Hotel',
		'description': '***: Not much atmosphere, but great views.',
	 	'alt_min': 300,
	 	'alt_max': 600,
	 	'delta_v': 150,
		'cost': 100000,
		'income': 1000,
	}
]

const METRES_PER_SCREEN_UNIT = 1.0 / 200.0;

func ship_config(name):
	for s in SHIP_CONFIG:
		if s.name == name:
			return s
	
	return {}

func screen_to_metres(vec):
	return vec / METRES_PER_SCREEN_UNIT
	
func metres_to_screen(vec):
	return vec * METRES_PER_SCREEN_UNIT

func get_pos_metres(node, pos):
	node.position = screen_to_metres(pos)
	
func set_pos_metres(node, pos):
	node.position = metres_to_screen(pos)
	
	