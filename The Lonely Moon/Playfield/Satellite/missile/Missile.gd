extends "res://Playfield/Satellite/Satellite.gd"

signal explode

const type = "missile"

var tail_x_scale = 0

func _ready():
    tail_x_scale = get_node("Tail").scale.x
    get_node("BlastRadius").connect("body_entered", self, "on_body_entered")


func _process(delta):
    var tail = get_node("Tail")
    tail.set_rotation(rand_range(-0.1, 0.1) - PI/2)
    tail.set_scale(Vector2(tail_x_scale * rand_range(0.9, 1.1), tail.scale.y))
    self.set_rotation(self.vel.angle())


func launch(p):
    in_orbit = false

    # Fudge numbers to get a nice spiral outwards
    self.leo_alt = 15
    self.leo_vel_theta = -10

    # Give up early
    #self.orbit_progress_threshold = 0.2
    self.orbit_progress_threshold = 0.05

    launch_alt = p.length()
    launch_vel_theta = -0.1
    launch_vel_r = 0.1
    self.pos = p


func enter_orbit():
    # When we 'enter orbit' it means we reached our target altitude.
    emit_signal("explode", null)
    

func on_body_entered(object):
    if object.type == "debris":
        return
    emit_signal("explode", object)
