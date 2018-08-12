extends KinematicBody2D

const BURN_RATE = 0.1

var pos = Vector2() setget set_pos, get_pos
var vel = Vector2(0.1, -0.1)

var config = {}
var alt_range = [0,1]
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


func _ready():
    deselect()


func _input_event(viewport, event, shape_idx):
    if event is InputEventMouseButton:
        if event.button_index == BUTTON_LEFT and event.pressed:
            emit_signal("clicked", self, event)


func _process(delta):
    uptime += delta


func configure(typename):
    type = typename
    config = global.ship_config(type)
    var region = config.region
    alt_range = [global.SPACE_REGIONS[region].alt_min, global.SPACE_REGIONS[region].alt_max]
    
func move_and_collide_metres(vec):
    return self.move_and_collide(global.metres_to_screen(vec))


func state():
    var alt = position.length()
    var in_range = alt < alt_range[1] && alt > alt_range[0]
    return {
        'in_range': in_range,
        'uptime': uptime,
        'type': type,
    }
