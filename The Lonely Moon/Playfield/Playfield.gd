extends Node2D

signal satellite_summary
signal satellite_selected

export (PackedScene) var Satellite

var selected_sat = null


func _ready():
    pass


func new_craft(type):
    var config = global.ship_config(type)

    var craft = Satellite.instance()
    add_child(craft)
    craft.add_to_group("satellites")
    craft.configure(type)

    var alt = rand_range(config.alt_min, config.alt_max)
    var theta = rand_range(0, 2 * PI)
    var x = alt * cos(theta)
    var y = alt * sin(theta)
    craft.position = Vector2(x, y)
    craft.vel = get_node('Physics').vel_for_pos(craft.pos)
    
    craft.connect("clicked", self, "satellite_clicked")


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


func satellite_clicked(sat):
    if selected_sat:
        selected_sat.deselect()
    selected_sat = sat
    sat.select()
    emit_signal("satellite_selected", sat)


func _process(delta):
    emit_signal("satellite_summary", delta, state())
    
    if selected_sat:
        if Input.is_action_pressed("burn_prograde"):
            selected_sat.burn_prograde(delta)
        elif Input.is_action_pressed("burn_retrograde"):
            selected_sat.burn_retrograde(delta)
    

func handle_game_over():
    get_tree().change_scene('res://GameOver.tscn')
