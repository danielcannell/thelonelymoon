extends Node2D

const ANGULAR_VELOCITY = 0.2 # Radians per second
const FALL_SPEED = 1
const MASS = 0.1

var theta = 0
var distance = 500

var pos = Vector2() setget set_pos, get_pos


func set_pos(pos):
    position = global.metres_to_screen(pos)


func get_pos():
    return global.screen_to_metres(position)


func _ready():
    pass


func _process(delta):
    theta += ANGULAR_VELOCITY * delta
    distance -= FALL_SPEED * delta
    position = distance * Vector2(sin(theta), cos(theta))