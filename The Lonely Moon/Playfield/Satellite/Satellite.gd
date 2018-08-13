extends KinematicBody2D

signal satellite_entered_orbit

const BURN_RATE = 0.1
const type = "satellite"

var glow_template = preload("res://Playfield/Satellite/Glow.tscn")
var staging_sfx = preload("res://Playfield/Satellite/StagingSound.tscn")


## state ##
var pos = Vector2() setget set_pos, get_pos
var vel = Vector2(0, 0)
var alt_range = [] setget , get_alt_range

var selected = false
var active = true
var invunerable = true
var uptime = 0
var delta_v_max = 1
var delta_v = 0

# Launch
var in_orbit = true
var leo_alt = 0
var leo_vel_theta = 0
var launch_alt = 0
var launch_vel_theta = 0
var launch_vel_r = 0
var orbit_progress_threshold = 0.99

# Glow
var has_glow = false
var animation = null
var launch_vehicle = null


# props
const default_props = {
    "region": "leo",
    "match_rot_to_vel": true,
    "delta_v": 0,
    "income": 0,
    "constellation_bonus": 0,
    "time_constant": 0,
    "drag_ratio": 0.1,
    "thrust": 0.1,
    "debris": {
        "radius": 0.5,
        "amount": 2,
        "impluse": 0.1,
    },
    "explosion": {
        "scale": 1
    }
}

var props = {}

signal clicked(sat)

func init(props=null):
    if props == null:
        if type in global.SHIP_CONFIG:
            props = global.SHIP_CONFIG[type]
        else:
            props = default_props

    self.props = props
    delta_v_max = self.props.delta_v / 100.0
    delta_v = delta_v_max


func launch_trajectory():
    var progress = (self.pos.length() - launch_alt) / (leo_alt - launch_alt)
    var vel_theta = launch_vel_theta + progress * (leo_vel_theta - launch_vel_theta)
    var vel_r = launch_vel_r * (1 - progress)
    var theta = self.pos.angle()
    vel = Vector2(
        vel_r * cos(theta) - vel_theta * sin(theta),
        vel_r * sin(theta) + vel_theta * cos(theta))

    if progress > self.orbit_progress_threshold:
        enter_orbit()

    return vel


func launch(lv, p, leo_alt, leo_vel_theta):
    in_orbit = false

    launch_vehicle = lv
    lv.scale = Vector2(1 / scale.x, 1 / scale.y)
    add_child(lv)

    self.leo_alt = leo_alt
    self.leo_vel_theta = -leo_vel_theta

    launch_alt = p.length()
    launch_vel_theta = -0.1
    launch_vel_r = 0.1
    self.pos = p


func enter_orbit():
    in_orbit = true
    remove_child(launch_vehicle)
    add_glow()
    
    var sfx = staging_sfx.instance()
    add_child(sfx)
    sfx.connect("finished", self, "remove_child", [sfx])
    
    emit_signal("satellite_entered_orbit", self, launch_vehicle)
    launch_vehicle = null


func add_glow():
    if has_glow:
        return

    # Debris and missiles don't have a glow
    if type in ["debris", "missile", "ark", "cleanup_sat"]:
        return

    has_glow = true
    var glow = glow_template.instance()
    glow.scale = Vector2(1 / scale.x, 1 / scale.y)
    add_child(glow)
    animation = glow.get_node("Animation")


func set_pos(pos):
    position = global.metres_to_screen(pos)


func get_pos():
    return global.screen_to_metres(position)


func get_alt_range():
    if props.region:
        return [global.SPACE_REGIONS[props.region].alt_min, global.SPACE_REGIONS[props.region].alt_max]
    else:
        return null


func destroy():
    active = false
    remove_from_group("satellites")


func select():
    selected = true
    var node = get_node("Selectbox")
    if node:
        node.set_default_color(Color(0.2, 1.0, 0.2, 1.0))


func deselect():
    selected = false
    var node = get_node("Selectbox")
    if node:
        node.set_default_color(Color(0.0, 0.0, 0.0, 0.0))


func burn(delta, is_prograde, is_fine):
    # Abandon launch trajectory if the player takes control
    if not in_orbit:
        enter_orbit()

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

    if not self.in_orbit or self.props.match_rot_to_vel:
        rotation = vel.angle() + PI/2


    if animation:
        animation.set_animation("good" if in_range() else "bad")


func move_and_collide_metres(vec):
    return self.move_and_collide(global.metres_to_screen(vec))


func state():
    return {
        'in_range': in_range(),
        'uptime': uptime,
        'type': type,
        'delta_v': 100 * delta_v,
        'delta_v_max': 100 * delta_v_max
    }
