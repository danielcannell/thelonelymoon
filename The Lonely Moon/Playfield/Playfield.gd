extends Container

export (PackedScene) var Satellite

func _ready():
	new_craft('spy_satellite')
	new_craft('spy_satellite')
	new_craft('science_station')


func new_craft(type):
	var config = global.ship_config(type)

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
