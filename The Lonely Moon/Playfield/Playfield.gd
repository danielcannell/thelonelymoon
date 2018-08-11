extends Container

export (PackedScene) var Satellite

var spawn_config = [
	{
		'name': 'spy_satellite',
	 	'alt_min': 500,
	 	'alt_max': 520,
	 	'delta_v': 100,
	},
	{
		'name': 'science_station',
	 	'alt_min': 600,
	 	'alt_max': 700,
	 	'delta_v': 150,
	}
]

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	new_craft('spy_satellite')
	new_craft('spy_satellite')
	new_craft('science_station')

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass

func new_craft(type):
	var config
	for t in spawn_config:
		if t.name == type:
			config = t
			break	
	
	var craft = Satellite.instance()
	add_child(craft)
	craft.add_to_group("satellites")
	
	var alt = rand_range(config.alt_min, config.alt_max)
	var theta = rand_range(0, 2 * PI)
	var x = alt * cos(theta)
	var y = alt * sin(theta)
	craft.position = Vector2(x, y)
	
func get_satellites():
	return get_tree().get_nodes_in_group("satellites")
