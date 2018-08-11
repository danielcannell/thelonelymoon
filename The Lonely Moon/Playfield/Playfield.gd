extends Node2D

signal satellite_summary

var Satellite = preload("res://Playfield/Satellite/Satellite.tscn");
var Debris = preload("res://Playfield/Satellite/debris/Debris.tscn");


var satellites = {
    "cube_sat": Satellite,
    "debris": Debris,
}


func _ready():
    pass


func new_craft(type):
    var config = global.ship_config(type)
    var craft
    if type in satellites:
        craft = satellites[type].instance()
    else:
        craft = Debris.instance()
        
        
    add_child(craft)
    craft.add_to_group("satellites")
    craft.configure(type)

    var alt = rand_range(config.alt_min, config.alt_max)
    var theta = rand_range(0, 2 * PI)
    var x = alt * cos(theta)
    var y = alt * sin(theta)
    craft.position = Vector2(x, y)
    craft.vel = get_node('Physics').vel_for_pos(craft.pos)


func destroy_craft(craft):
    remove_child(craft)
    craft.free()


func get_satellites():
    return get_tree().get_nodes_in_group("satellites")


func state():
    var st = []
    for sat in get_satellites():
        st.append(sat.state())
    return st


func _process(delta):
    emit_signal("satellite_summary", delta, state())
    

func handle_game_over():
    get_tree().change_scene('res://GameOver.tscn')
