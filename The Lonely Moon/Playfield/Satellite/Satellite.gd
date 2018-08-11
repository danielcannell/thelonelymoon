extends Sprite

var pos = Vector2() setget set_pos, get_pos
var vel = Vector2(0.1, -0.1)

var config = {}
var type = ""
var uptime = 0

func set_pos(pos):
    position = global.metres_to_screen(pos)


func get_pos():
    return global.screen_to_metres(position)


func _ready():
    pass


func _process(delta):
    uptime += delta


func configure(typename):
	type = typename
	config = global.ship_config(type)


func state():
	var alt = sqrt(pow(position[0], 2) + pow(position[1], 2))
	var in_range = alt < config.alt_max && alt > config.alt_min
	return {
		'in_range': in_range,
		'uptime': uptime,
		'type': type,
	}
