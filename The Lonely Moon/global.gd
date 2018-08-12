extends Node

func _ready():
    pass

const MENU_CONFIG = [
    {
        'id': 'press_conference',
        'display_name': 'Hold Press Conference',
        'description': 'Generate hype, get some of that VC funding!',
        'type': 'fundraise',
        'cost': 0,
        'build_time': 1
    },
    {
        'id': 'indiegogo',
        'display_name': 'Indiegogo',
        'description': 'Venture capital not working out? Try taking money from strangers!',
        'type': 'fundraise',
        'cost': 200,
        'build_time': 2
    },
    {
        'id': 'cube_sat',
        'display_name': 'CubeSat',
        'description': 'Pretend that you\'re NASA, on the cheap.',
        'type': 'satellite',
        'cost': 500,
        'build_time': 1,
    },
    {
        'id': 'spy_satellite',
        'display_name': 'Spy Satellite',
        'description': 'Keep an eye on the neighbours.',
        'type': 'satellite',
        'cost': 1000,
        'build_time': 1,
    },
    {
        'id': 'science_station',
        'display_name': 'Science Station',
        'description': 'We\'re doing science and we\'re still alive <3',
        'type': 'satellite',
        'cost': 10000,
        'build_time': 20,
    },
    { 
        'id': 'space_hotel',
        'display_name': 'Space Hotel',
        'description': '"****: Not much atmosphere, but great views."',
        'type': 'satellite',
        'cost': 100000,
        'build_time': 30,
    },
    {
        'id': 'ark',
        'display_name': 'The Ark',
        'description': 'Escape the world\'s destruction in the lap of refined luxury!',
        'type': 'ark',
        'cost': 999999,
        'build_time': 60,
    }
]

const SHIP_CONFIG = {
    'cube_sat': {
        'region': 'leo',
        'delta_v': 50,
        'income': 10,
        'time_constant': 5000,
    },
    'spy_satellite': {
        'region': 'region2',
        'delta_v': 100,
        'income': 25,
        'time_constant': 5000,
    },
    'science_station': {
        'region': 'region3',
        'delta_v': 150,
        'income': 100,
        'time_constant': 5000,
    },
    'space_hotel': {
        'region': 'region4',
        'delta_v': 150,
        'income': 10000,
        'time_constant': 5000,
    }
}

const SPACE_REGIONS = {
    'leo': {
        'alt_min': 100,
        'alt_max': 200,
    },
    'region2': {
        'alt_min': 500,
        'alt_max': 520,
    },
    'region3': {
        'alt_min': 600,
        'alt_max': 700,
    },
    'region4': {
        'alt_min': 300,
        'alt_max': 600,
    }
}

const FUNDRAISE_CONFIG = {
    'press_conference': {
        'raised_min': 500,
        'raised_max': 1000,
    },
    'indiegogo': {
        'raised_min': 2000,
        'raised_max': 4000,
    }
}

const METRES_PER_SCREEN_UNIT = 1.0 / 200.0;

func ship_config(name):
    return SHIP_CONFIG[name]

func screen_to_metres(vec):
    return vec * METRES_PER_SCREEN_UNIT
    
func metres_to_screen(vec):
    return vec / METRES_PER_SCREEN_UNIT

func get_pos_metres(node):
    return screen_to_metres(node.position)
    
func set_pos_metres(node, pos):
    node.position = metres_to_screen(pos)

func current_scale():
    return get_node('/root/Node/Playfield/Camera').zoom.x