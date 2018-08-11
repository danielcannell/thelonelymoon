extends Node2D

signal satellite_summary
signal satellite_selected

var Debris = preload("res://Playfield/Satellite/debris/Debris.tscn");
var SpySatellite = preload("res://Playfield/Satellite/spy_satellite/SpySatellite.tscn");
var CubeSat = preload("res://Playfield/Satellite/cube_sat/CubeSat.tscn");
var ScienceStation = preload("res://Playfield/Satellite/science_station/ScienceStation.tscn");
var SpaceHotel =  preload("res://Playfield/Satellite/space_hotel/SpaceHotel.tscn");


var satellites = {
    "debris": Debris,
    "cube_sat": CubeSat,
    "spy_satellite": SpySatellite,
    "science_station": ScienceStation,
    "space_hotel": SpaceHotel,
}

var selected_sat = null

var clicks = []


func _ready():
    var orbit = get_node('Orbit')


func _unhandled_input(event):
    if event is InputEventMouseButton:
        if event.button_index == 1:
            if event.pressed:
                clicks.append(event)


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
    
    craft.connect("clicked", self, "satellite_clicked")


func destroy_craft(craft):
    remove_child(craft)
    craft.remove_from_group("satellites")
    # craft.free()


func get_satellites():
    return get_tree().get_nodes_in_group("satellites")


func state():
    var st = []
    for sat in get_satellites():
        st.append(sat.state())
    return st


func select_satellite(sat):
    if selected_sat:
        selected_sat.deselect()
    selected_sat = sat

    var good_orbit_range = get_node('GoodOrbitRange')
    var orbit = get_node('Orbit')

    if sat:
        sat.select()
        var alt_range = sat.alt_range()
        good_orbit_range.set_range(alt_range[0], alt_range[1])
        good_orbit_range.visible = true
        orbit.visible = true
    else:
        good_orbit_range.visible = false
        orbit.visible = false
    
    emit_signal("satellite_selected", sat)


func satellite_clicked(sat, event):
    # Eat this click
    if event in clicks:
        clicks.remove(clicks.find(event))

    select_satellite(sat)


func _process(delta):
    emit_signal("satellite_summary", delta, state())

    for click_left in clicks:
        # This click was not eaten by a satellite
        select_satellite(null)
    clicks.clear()
    
    if selected_sat:
        if Input.is_action_pressed("burn_prograde"):
            selected_sat.burn_prograde(delta)
        elif Input.is_action_pressed("burn_retrograde"):
            selected_sat.burn_retrograde(delta)
            
        var predicted_orbit = get_node('Physics').predict_orbit(selected_sat)
        var orbit = get_node('Orbit')
        orbit.points = PoolVector2Array(predicted_orbit)
        orbit.width = 2 * global.current_scale()
    

func handle_game_over():
    get_tree().change_scene('res://GameOver.tscn')
