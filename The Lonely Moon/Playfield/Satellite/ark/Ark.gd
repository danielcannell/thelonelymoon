extends "res://Playfield/Satellite/Satellite.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
const type = "ark"

func _ready():
    # Called when the node is added to the scene for the first time.
    # Initialization here
    pass

func _process(delta):
    if in_range():
        get_tree().change_scene("res://Victory.tscn")
