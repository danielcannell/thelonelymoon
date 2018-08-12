extends "res://Playfield/Satellite/Satellite.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

const type = "missile";

var tail_x_scale = 0

func _ready():
    # Called when the node is added to the scene for the first time.
    # Initialization here
    tail_x_scale = get_node("Tail").scale.x

func _process(delta):
    var tail = get_node("Tail")
    tail.set_rotation(rand_range(-0.1, 0.1))
    tail.set_scale(Vector2(tail_x_scale * rand_range(0.9, 1.1), tail.scale.y))
    # self.look_at(self.vel.normalized())
    self.set_rotation(self.vel.angle())
    

