extends KinematicBody2D

const BURN_RATE = 0.1

var pos = Vector2() setget set_pos, get_pos
var vel = Vector2(0, 0)

var active = true
var config = {}
var alt_range = [0,1]
var type = ""
var uptime = 0
var delta_v = 0
var invunerable = true

# Launch
var in_orbit = true
var leo_alt = 0
var leo_vel_theta = 0
var launch_alt = 0
var launch_vel_theta = 0
var launch_vel_r = 0

signal clicked(sat)


func launch_trajectory():
    var progress = (self.pos.length() - launch_alt) / (leo_alt - launch_alt)
    var vel_theta = launch_vel_theta + progress * (leo_vel_theta - launch_vel_theta)
    var vel_r = launch_vel_r * (1 - progress)
    var theta = self.pos.angle()
    vel = Vector2(
        vel_r * cos(theta) - vel_theta * sin(theta),
        vel_r * sin(theta) + vel_theta * cos(theta))

    if progress > 0.99:
        in_orbit = true

    return vel


func launch(p, leo_alt, leo_vel_theta):
    in_orbit = false

    self.leo_alt = leo_alt
    self.leo_vel_theta = leo_vel_theta

    launch_alt = p.length()
    launch_vel_theta = 0.1
    launch_vel_r = 0.1
    self.pos = p


func set_pos(pos):
    position = global.metres_to_screen(pos)


func get_pos():
    return global.screen_to_metres(position)

func destroy():
    active = false
    remove_from_group("satellites")


func select():
    get_node("Selectbox").set_default_color(Color(0.2, 1.0, 0.2, 1.0))


func deselect():
    get_node("Selectbox").set_default_color(Color(0.0, 0.0, 0.0, 0.0))


func burn(delta, is_prograde, is_fine):
    # Abandon launch trajectory if the player takes control
    in_orbit = true

    var dv = delta * BURN_RATE
    if is_fine:
        dv *= 0.2
    if dv > delta_v:
        dv = delta_v
    delta_v -= dv
    if not is_prograde:
        dv = -dv
    vel += vel.normalized() * dv


func _ready():
    deselect()


func _input_event(viewport, event, shape_idx):
    if event is InputEventMouseButton:
        if event.button_index == BUTTON_LEFT and event.pressed:
            emit_signal("clicked", self, event)


func _process(delta):
    uptime += delta

    if invunerable and uptime > 0.1:
        invunerable = false


func configure(typename):
    type = typename
    config = global.ship_config(type)
    var region = config.region
    alt_range = [global.SPACE_REGIONS[region].alt_min, global.SPACE_REGIONS[region].alt_max]
    delta_v = config['delta_v']

func move_and_collide_metres(vec):
    return self.move_and_collide(global.metres_to_screen(vec))


func state():
    var alt = position.length()
    var in_range = alt < alt_range[1] && alt > alt_range[0]
    return {
        'in_range': in_range,
        'uptime': uptime,
        'type': type,
        'delta_v': delta_v,
    }
