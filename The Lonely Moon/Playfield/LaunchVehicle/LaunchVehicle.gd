extends Area2D

var tail_x_scale = 0

func _ready():
    tail_x_scale = get_node("Tail").scale.x

func _process(delta):
    var tail = get_node("Tail")
    tail.set_rotation(rand_range(-0.1, 0.1) - PI/2)
    tail.set_scale(Vector2(tail_x_scale * rand_range(0.9, 1.1), tail.scale.y))
