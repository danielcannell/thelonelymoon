extends Node

var id_display_lookup = {}
var id_menu_lookup = {}


func _ready():
    for m in MENU_CONFIG:
        id_menu_lookup[m.id] = m
        id_display_lookup[m.id] = m['display_name']
    id_display_lookup['debris'] = "Debris"
    id_display_lookup['debris.used_launch_vehicle'] = "Debris"
    id_display_lookup['missile'] = "Missile"


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
        'cost': 20,
        'build_time': 3
    },
    {
        'id': 'cube_sat',
        'display_name': 'CubeSat',
        'description': 'Pretend that you\'re NASA, on the cheap.',
        'type': 'satellite',
        'cost': 150,
        'build_time': 1,
    },
    {
        'id': 'laser_charge',
        'display_name': 'Laser Charge',
        'description': 'Clear the skies with a blast of light.',
        'type': 'laser',
        'cost': 1000,
        'build_time': 5,
    },
    {
        'id': 'cleanup_sat',
        'display_name': 'Laser Satellite',
        'description': 'Clear space with a blast of light (push space).',
        'type': 'satellite',
        'cost': 1000,
        'build_time': 5,
    },
    {
        'id': 'science_station',
        'display_name': 'Science Station',
        'description': 'We\'re doing science and we\'re still alive <3',
        'type': 'satellite',
        'cost': 15000,
        'build_time': 20,
    },
    {
        'id': 'spy_satellite',
        'display_name': 'Spy Satellite',
        'description': 'Keep an eye on the neighbours.',
        'type': 'satellite',
        'cost': 50000,
        'build_time': 5,
    },
    {
        'id': 'space_hotel',
        'display_name': 'Space Hotel',
        'description': '"****: Not much atmosphere, but great views."',
        'type': 'satellite',
        'cost': 200000,
        'build_time': 30,
    },
    {
        'id': 'ark',
        'display_name': 'The Ark',
        'description': 'Escape the world\'s destruction in the lap of refined luxury!',
        'type': 'satellite',
        'cost': 9999999,
        'build_time': 60,
    }
]

const SHIP_CONFIG = {
    'cube_sat': {
        "match_rot_to_vel": true,
        'region': 'leo',
        'delta_v': 40,
        'income': 20,
        'constellation_bonus': 1.2,
        'time_constant': 60,
        'drag_ratio': 0.1,
        'thrust': 0.1,
        "debris": {
            "radius": 0.03,
            "amount": 3,
            "impluse": 0.01,
        },
        "explosion": {
            "scale": 0.4
        }
    },
    'cleanup_sat': {
        "match_rot_to_vel": true,
        'region': null,
        'delta_v': 100,
        'income': 0,
        'constellation_bonus': 0,
        'time_constant': 1,
        'drag_ratio': 3,
        'thrust': 0.1,
        "debris": {
            "radius": 0.03,
            "amount": 3,
            "impluse": 0.01,
        },
        "explosion": {
            "scale": 0.4
        }
    },
    'spy_satellite': {
        "match_rot_to_vel": true,
        'region': 'region2',
        'delta_v': 50,
        'income': 10000,
        'constellation_bonus': 1,
        'time_constant': 60,
        'drag_ratio': 0.3,
        'thrust': 0.1,
        "debris": {
            "radius": 0.04,
            "amount": 5,
            "impluse": 0.02,
        },
        "explosion": {
            "scale": 0.6
        }
    },
    'science_station': {
        "match_rot_to_vel": true,
        'region': 'region3',
        'delta_v': 50,
        'income': 500,
        'constellation_bonus': 0,
        'time_constant': 200,
        'drag_ratio': 0.7,
        'thrust': 0.1,
        "radius":  0.04,
        "debris": {
            "radius": 0.05,
            "amount": 10,
            "impluse": 0.01,
        },
        "explosion": {
            "scale": 0.8
        }
    },
    'space_hotel': {
        "match_rot_to_vel": true,
        'region': 'region4',
        'delta_v': 50,
        'income': 10000,
        'constellation_bonus': 0.5,
        'time_constant': 40,
        'drag_ratio': 2,
        'thrust': 0.1,
        "radius":  0.04,
        "debris": {
            "radius": 0.07,
            "amount": 20,
            "impluse": 0.01,
        },
        "explosion": {
            "scale": 1
        }
    },
    'ark': {
        "match_rot_to_vel": true,
        'region': 'outer_space',
        'delta_v': 75,
        'income': 0,
        'constellation_bonus': 0,
        'time_constant': 1,
        'drag_ratio': 0.2,
        'thrust': 0.01,
        "radius":  0.4,
        "debris": {
            "radius": 0.1,
            "amount": 50,
            "impluse": 0.5,
        },
        "explosion": {
            "scale": 2
        }
    },
    "debris": {
        "match_rot_to_vel": false,
        'region': null,
        'delta_v': 0,
        'income': 0,
        'constellation_bonus': 0,
        'time_constant': 0,
        'drag_ratio': 0.12,
        'thrust': 0,
        "radius":  0.04,
        "debris": null,
        "explosion": {
            "scale": 0.2
        }
    },
    "debris.used_launch_vehicle": {
        "match_rot_to_vel": false,
        'region': null,
        'delta_v': 0,
        'income': 0,
        'constellation_bonus': 0,
        'time_constant': 0,
        'drag_ratio': 1.5,
        'thrust': 0,
        "radius":  0.04,
        "debris": {
            "radius": 0.05,
            "amount": 3,
            "impluse": 0.1,
        },
        "explosion": {
            "scale": 0.7
        }
    },
    "missile": {
        "match_rot_to_vel": true,
        'region': null,
        'delta_v': 0,
        'income': 0,
        'constellation_bonus': 0,
        'time_constant': 0,
        'drag_ratio': 0.1,
        "radius":  0.04,
        "debris": {
            "radius": 0.07,
            "amount": 15,
            "impluse": 0.07,
        },
        "explosion": {
            "scale": 1.5
        }
    }
}

const SPACE_REGIONS = {
    'leo': {
        'alt_min': 100,
        'alt_max': 250,
    },
    'region2': {
        'alt_min': 500,
        'alt_max': 520,
    },
    'region3': {
        'alt_min': 600,
        'alt_max': 1000,
    },
    'region4': {
        'alt_min': 300,
        'alt_max': 600,
    },
    'outer_space': {
        'alt_min': 2000,
        'alt_max': 6000,
    },
}

const FUNDRAISE_CONFIG = {
    'press_conference': {
        'raised_min': 5,
        'raised_max': 15,
    },
    'indiegogo': {
        'raised_min': 100,
        'raised_max': 200,
    }
}

const LASER_CONFIG = {
    'laser_charge': {
        'time_earned': 4,
    }
}

const NOTIFICATION_TYPE = {
    'GOOD': 0,
    'BAD': 1,
    'INFO': 2
}

const METRES_PER_SCREEN_UNIT = 1.0 / 200.0;

func ship_config(name):
    if name in SHIP_CONFIG:
        return SHIP_CONFIG[name]
    else:
        return null

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


func _filter_in_range_satellites(sats, type):
    var matches = []
    for s in sats:
        if s.type == type and s.in_range():
            matches.append(s)
    return matches

func constellation_size(sats, type):
    return _filter_in_range_satellites(sats, type).size()


func deep_copy(v):
    var t = typeof(v)

    if t == TYPE_DICTIONARY:
        var d = {}
        for k in v:
            d[k] = deep_copy(v[k])
        return d

    elif t == TYPE_ARRAY:
        var d = []
        d.resize(len(v))
        for i in range(len(v)):
            d[i] = deep_copy(v[i])
        return d

    elif t == TYPE_OBJECT:
        if v.has_method("duplicate"):
            return v.duplicate()
        else:
            print("Found an object, but I don't know how to copy it!")
            return v

    else:
        # Other types should be fine,
        # they are value types (except poolarrays maybe)
        return v

func merge_dict(target, patch):
    for key in patch:
        if target.has(key):
            var tv = target[key]
            if typeof(tv) == TYPE_DICTIONARY:
                merge_dict(tv, patch[key])
            else:
                target[key] = patch[key]
        else:
            target[key] = patch[key]
