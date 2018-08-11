extends KinematicBody2D

const BURN_RATE = 0.1

var pos = Vector2() setget set_pos, get_pos
var vel = Vector2(0.1, -0.1)

var config = {}
var type = ""
var uptime = 0


signal clicked(sat)


func set_pos(pos):
    position = global.metres_to_screen(pos)


func get_pos():
    return global.screen_to_metres(position)


func select():
    get_node("Selectbox").set_default_color(Color(0.2, 1.0, 0.2, 1.0))
    

func deselect():
    get_node("Selectbox").set_default_color(Color(0.0, 0.0, 0.0, 0.0))


func burn_prograde(delta):
    vel += vel.normalized() * delta * BURN_RATE


func burn_retrograde(delta):
    vel -= vel.normalized() * delta * BURN_RATE


func alt_range():
    return [
        global.SHIP_CONFIG[type]['alt_min'],
        global.SHIP_CONFIG[type]['alt_max']
    ]


func _ready():
    deselect()


func _input_event(viewport, event, shape_idx):
    if event is InputEventMouseButton:
        if event.button_index == BUTTON_LEFT and event.pressed:
            emit_signal("clicked", self)


func _process(delta):
    uptime += delta


func configure(typename):
    type = typename
    config = global.ship_config(type)


func state():
    var alt = position.length()
    var in_range = alt < config.alt_max && alt > config.alt_min
    return {
        'in_range': in_range,
        'uptime': uptime,
        'type': type,
    }
