extends Node2D

const ANGULAR_VELOCITY = 0.2 # Radians per second
const FALL_SPEED = 1
const MASS = 0.005

var theta = 0
var distance = 500

func _ready():
    pass

func _process(delta):
    theta += ANGULAR_VELOCITY * delta
    distance -= FALL_SPEED * delta
    position = distance * Vector2(sin(theta), cos(theta))