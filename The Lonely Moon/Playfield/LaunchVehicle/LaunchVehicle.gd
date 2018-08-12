extends Area2D

var engine_enabled = true setget set_engine_enabled, get_engine_enabled

var tail_x_scale = 0

func _ready():
    tail_x_scale = get_node("Tail").scale.x

func _process(delta):
    var tail = get_node("Tail")
    tail.set_rotation(rand_range(-0.1, 0.1) - PI/2)
    tail.set_scale(Vector2(tail_x_scale * rand_range(0.9, 1.1), tail.scale.y))

func get_engine_enabled():
    return engine_enabled

func set_engine_enabled(state):
    var tail = get_node("Tail")
    if state:
        tail.visible = true
    else:
        tail.visible = false

