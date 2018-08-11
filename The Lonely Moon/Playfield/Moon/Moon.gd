extends Node2D

signal game_over;

const ANGULAR_VELOCITY = 0.2 # Radians per second
const FALL_SPEED = 40
const MASS = 0.1

var theta = 0
var distance = 5000

var pos = Vector2() setget set_pos, get_pos


func set_pos(pos):
    position = global.metres_to_screen(pos)


func get_pos():
    return global.screen_to_metres(position)


func _ready():
    self.connect("game_over", self, "game_over_fn")


func _process(delta):
    theta += ANGULAR_VELOCITY * delta
    distance -= FALL_SPEED * delta
    position = distance * Vector2(sin(theta), cos(theta))
    if overlaps_body(get_node('../Earth')):
        emit_signal("game_over")
