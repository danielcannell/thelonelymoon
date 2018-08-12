extends Node2D

signal game_over;

const ANGULAR_VELOCITY = 0.2 # Radians per second
const FALL_SPEED = 0.002
const MASS = 0.123

var theta = 0
var start_distance = 5000
var distance

var pos = Vector2() setget set_pos, get_pos


func _ready():
    distance = start_distance


func set_pos(pos):
    position = global.metres_to_screen(pos)


func get_pos():
    return global.screen_to_metres(position)


func _process(delta):
    theta += ANGULAR_VELOCITY * delta

    var delta_distance = 0.1
    if distance > 150:
        delta_distance = distance * (1 - exp(-delta * FALL_SPEED))

    distance -= delta_distance
    position = distance * Vector2(sin(theta), cos(theta))
    if overlaps_body(get_node('../Earth')):
        get_node('..').handle_game_over()
