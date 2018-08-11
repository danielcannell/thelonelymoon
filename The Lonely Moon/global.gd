extends Node

func _ready():
	pass

const MENU_CONFIG = [
	{
		'id': 'cube_sat',
		'display_name': 'CubeSat',
		'description': 'Pretend that you\'re NASA, on the cheap.',
		'type': 'satellite',
		'cost': 500,
		'build_time': 5,
	},
	{
		'id': 'spy_satellite',
		'display_name': 'Spy Satellite',
		'description': 'Keep an eye on the neighbours.',
		'cost': 1000,
		'build_time': 15,
	},
	{
		'id': 'science_station',
		'display_name': 'Science Station',
		'description': 'We\'re doing science and we\'re still alive',
		'cost': 10000,
		'build_time': 20,
	},
	{ 
		'id': 'space_hotel',
		'display_name': 'Space Hotel',
		'description': '"***: Not much atmosphere, but great views."',
		'cost': 100000,
		'build_time': 30,
	}
]

const SHIP_CONFIG = {
	'cube_sat': {
	 	'alt_min': 350,
	 	'alt_max': 380,
	 	'delta_v': 50,
		'income': 10,
	},
	'spy_satellite': {
	 	'alt_min': 500,
	 	'alt_max': 520,
	 	'delta_v': 100,
		'income': 25,
	},
	'science_station': {
	 	'alt_min': 600,
	 	'alt_max': 700,
	 	'delta_v': 150,
		'income': 100,
	},
	'space_hotel': {
	 	'alt_min': 300,
	 	'alt_max': 600,
	 	'delta_v': 150,
		'cost': 100000,
	}
}

const METRES_PER_SCREEN_UNIT = 1.0 / 200.0;

func ship_config(name):
	return SHIP_CONFIG[name]

func screen_to_metres(vec):
	return vec / METRES_PER_SCREEN_UNIT
	
func metres_to_screen(vec):
	return vec * METRES_PER_SCREEN_UNIT

func get_pos_metres(node, pos):
	node.position = screen_to_metres(pos)
	
func set_pos_metres(node, pos):
	node.position = metres_to_screen(pos)
	
	