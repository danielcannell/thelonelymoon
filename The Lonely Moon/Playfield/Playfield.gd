extends Container

export (PackedScene) var Satellite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	new_craft('foo')
	new_craft('foo')
	new_craft('foo')
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func new_craft(type):
	# create a new craft
	var craft = Satellite.instance()
	add_child(craft)
	craft.add_to_group("satellites")

func get_satellites():
	return get_tree().get_nodes_in_group("satellites")
