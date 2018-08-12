extends Area2D

const MASS = 1
const ANGULAR_VELOCITY = 2

const type = "earth"

var pos = Vector2() setget set_pos, get_pos


func set_pos(pos):
    position = global.metres_to_screen(pos)

func get_pos():
    return global.screen_to_metres(position)

func _on_body_entered(body, name):
    # called when a Physics body entered the earth, or its laser beam
    get_node("..").no_debris_collision(body, name)

func _ready():
    connect("body_entered", self, "_on_body_entered", ["Earth"])
    get_node("LaserBeam").connect("body_entered", self, "_on_body_entered", ["Laser"])


func _process(delta):
    rotate(-ANGULAR_VELOCITY * delta)


func fire_laser():
    var laser_beam = get_node("LaserBeam")
    laser_beam.visible = true
    laser_beam.monitoring = true


func stop_laser():
    var laser_beam = get_node("LaserBeam")
    laser_beam.visible = false
    laser_beam.monitoring = false


func show_laser_cannon():
    get_node("laser_cannon").visible = true
