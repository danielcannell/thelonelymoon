extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass


var METRES_PER_SCREEN_UNIT = 1 / 200;


func screen_to_metres(vec):
	return vec / METRES_PER_SCREEN_UNIT
	
func metres_to_screen(vec):
	return vec * METRES_PER_SCREEN_UNIT

func get_pos_metres(node, pos):
	node.position = screen_to_metres(pos)
	
func set_pos_metres(node, pos):
	node.position = metres_to_screen(pos)
	
	