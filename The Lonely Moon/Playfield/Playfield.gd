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

var inactive_debris = []


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
    craft.set_collision_layer_bit(1, false)
    craft.set_collision_layer_bit(0, false)
    craft.remove_from_group("satellites")

func craft_collision(craft1, craft2):
    if craft1.type == "debris" and craft2.type == "debris":
        return
        
    if not craft1.active or not craft2.active:
        return
    
    var avg_vel = (craft1.vel + craft2.vel) / 2.0
    var avg_pos = (craft1.pos + craft2.pos) / 2.0

    var craft

    var total = 0

    if craft1.type != "debris":
        destroy_craft(craft1)
        total += 3

    if craft2.type != "debris":
        destroy_craft(craft2)
        total += 3


    for i in range(total):
        var angle = i * (2 * PI) / 5
        var radius = 0.03
        var vel_strength = 0.01
        var x = cos(angle)
        var y = sin(angle)
    
        var craft_pos = avg_pos + Vector2(radius*x, radius*y)
        var craft_vel = avg_vel + Vector2(vel_strength*x, vel_strength*y)
        craft = Debris.instance()
        add_child(craft)

        craft.vel = craft_vel
        craft.pos = craft_pos
        craft.active = false

        inactive_debris.append(craft)


func get_satellites():
    return get_tree().get_nodes_in_group("satellites")


func state():
    var st = []
    for sat in get_satellites():
        if sat.active and sat.type != "debris":
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


func _physics_process(delta):
    pass


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

    for d in inactive_debris:
        var colliding_bodies = d.get_node("PlacementArea").get_overlapping_bodies()
        d.get_node("PlacementArea").monitorable = false
        d.get_node("PlacementArea").monitoring = false
        if colliding_bodies: 
            destroy_craft(d)
        else:
            d.add_to_group("satellites")
            d.active = true
    
    inactive_debris = []
    

func handle_game_over():
    get_tree().change_scene('res://GameOver.tscn')
