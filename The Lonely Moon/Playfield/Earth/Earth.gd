extends KinematicBody2D

const MASS = 1

var pos = Vector2() setget set_pos, get_pos


func set_pos(pos):
    position = global.metres_to_screen(pos)


func get_pos():
    return global.screen_to_metres(position)


func _ready():
    pass

func _process(delta):
    pass
