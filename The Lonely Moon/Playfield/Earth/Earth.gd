extends KinematicBody2D

const MASS = 1
const ANGULAR_VELOCITY = 2

const type = "earth"

var pos = Vector2() setget set_pos, get_pos


func set_pos(pos):
    position = global.metres_to_screen(pos)


func get_pos():
    return global.screen_to_metres(position)


func _ready():
    pass

func _process(delta):
    rotate(-ANGULAR_VELOCITY * delta)
