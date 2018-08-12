extends KinematicBody2D

const BURN_RATE = 0.1
const type = "satellite"


## state ##
var pos = Vector2() setget set_pos, get_pos
var vel = Vector2(0, 0)
var alt_range = [] setget , get_alt_range

var active = true
var invunerable = true
var uptime = 0
var delta_v = 0

# Launch
var in_orbit = true
var leo_alt = 0
var leo_vel_theta = 0
var launch_alt = 0
var launch_vel_theta = 0
var launch_vel_r = 0


# props
var props = {
    "region": "leo",
    "delta_v": 50,
    "income": 10,
    "time_constant": 5000,
    "drag_ratio": 0.1,
    "thrust": 0.1,
}

signal clicked(sat)

func init(props=null):
    if props == null:
        if type in global.SHIP_CONFIG:
            props = global.SHIP_CONFIG[type]

    self.props = props
    delta_v = self.props.delta_v / 100.0

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
    self.leo_vel_theta = -leo_vel_theta

    launch_alt = p.length()
    launch_vel_theta = -0.1
    launch_vel_r = 0.1
    self.pos = p


func set_pos(pos):
    position = global.metres_to_screen(pos)


func get_pos():
    return global.screen_to_metres(position)

func get_alt_range():
    return [global.SPACE_REGIONS[props.region].alt_min, global.SPACE_REGIONS[props.region].alt_max]

func destroy():
    active = false
    remove_from_group("satellites")


func select():
    var node = get_node("Selectbox")
    if node:
        node.set_default_color(Color(0.2, 1.0, 0.2, 1.0))


func deselect():
    var node = get_node("Selectbox")
    if node:
        node.set_default_color(Color(0.0, 0.0, 0.0, 0.0))


func burn(delta, is_prograde, is_fine):
    # Abandon launch trajectory if the player takes control
    in_orbit = true

    var dv = delta * props['thrust']
    if is_fine:
        dv *= 0.2
    if dv > delta_v:
        dv = delta_v
    delta_v -= dv
    if not is_prograde:
        dv = -dv
    vel += vel.normalized() * dv


func in_range():
    if props.region:
        var alt = position.length()
        return alt < self.alt_range[1] && alt > self.alt_range[0]
    return false


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

func move_and_collide_metres(vec):
    return self.move_and_collide(global.metres_to_screen(vec))


func state():
    return {
        'in_range': in_range(),
        'uptime': uptime,
        'type': type,
        'delta_v': 100 * delta_v,
    }
