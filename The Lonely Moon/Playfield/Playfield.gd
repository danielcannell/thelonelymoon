extends Node2D

signal satellite_summary
signal satellite_selected

var Debris = preload("res://Playfield/Satellite/debris/Debris.tscn");
var Explosion = preload("res://Playfield/Satellite/Explosion.tscn");
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
var dragging = false

var inactive_debris = []


func _ready():
    var orbit = get_node('Orbit')


func _unhandled_input(event):
    if event is InputEventMouseButton:
        if event.button_index == 1:
            clicks.append(event)

    if event is InputEventMouseMotion:
        var sb = get_node("SelectionBox")
        var viewport_pos = event.position
        var sb_transform = sb.get_global_transform_with_canvas()
        var local_pos = (viewport_pos - sb_transform.get_origin()) / sb_transform.get_scale()
        get_node("SelectionBox").set_drag_end(local_pos)


func show_satellite_range(id):
    var region = global.SHIP_CONFIG[id].region
    var alt_min = global.SPACE_REGIONS[region].alt_min
    var alt_max = global.SPACE_REGIONS[region].alt_max
    var orbit_range = get_node("ShopOrbitRange")
    orbit_range.set_range(alt_min, alt_max)
    orbit_range.visible = true


func hide_satellite_range():
    get_node("ShopOrbitRange").visible = false


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

    var region = config.region
    var alt = rand_range(global.SPACE_REGIONS[region].alt_min, global.SPACE_REGIONS[region].alt_max)

    var theta = rand_range(0, 2 * PI)
    var x = alt * cos(theta)
    var y = alt * sin(theta)
    craft.position = Vector2(x, y)
    craft.vel = get_node('Physics').vel_for_pos(craft.pos)

    craft.connect("clicked", self, "satellite_clicked")


func destroy_craft(craft):
    if selected_sat == craft:
        select_satellite(null) 

    remove_child(craft)
    craft.set_collision_layer_bit(1, false)
    craft.set_collision_layer_bit(0, false)
    craft.remove_from_group("satellites")


func explode(position):
    var p = position
    var splode = Explosion.instance()
    add_child(splode)
    splode.position = p
    splode.connect("animation_finished", self, "remove_child", [splode])
    splode.show()
    splode.play()


func earth_collision(craft):
    explode(craft.position)
    destroy_craft(craft)


func create_debris(pos, vel, amount):
    var craft
    var angle
    var x
    var y
    var radius
    var vel_strength
    var craft_pos
    var craft_vel

    for i in range(amount):
        angle = i * (2 * PI) / amount
        x = cos(angle)
        y = sin(angle)

        radius = 0.01 + randf() * 0.03
        vel_strength = 0.002 + randf() * 0.002

        craft_pos = pos + Vector2(radius*x, radius*y)
        craft_vel = vel + Vector2(vel_strength*x, vel_strength*y)
        craft = Debris.instance()
        add_child(craft)

        craft.vel = craft_vel
        craft.pos = craft_pos
        craft.active = false

        inactive_debris.append(craft)


func craft_collision(craft1, craft2):
    if craft1.type == "debris" and craft2.type == "debris":
        return
        
    if not craft1.active or not craft2.active:
        return

    if craft1.type != "debris":
        create_debris(craft1.pos, craft1.vel, 4)
        explode(craft1.position)
        destroy_craft(craft1)


    if craft2.type != "debris":
        create_debris(craft2.pos, craft2.vel, 4)
        explode(craft2.position)
        destroy_craft(craft2)


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
        var alt_range = sat.alt_range
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

    dragging = false

    select_satellite(sat)


func _physics_process(delta):
    pass


func start_dragging(event):
    dragging = true
    var sb = get_node("SelectionBox")
    var viewport_pos = event.position
    var sb_transform = sb.get_global_transform_with_canvas()
    var local_pos = (viewport_pos - sb_transform.get_origin()) / sb_transform.get_scale()
    sb.set_drag_start(local_pos)
    sb.visible = true


func finish_dragging(event):
    if not dragging:
        return

    var sb = get_node("SelectionBox")
    sb.visible = false

    var sats = sb.get_satellites_contained()
    var center = sb.get_center()
    var nearest = null
    var nearest_dist = 99999999999999
    for sat in sats:
        var dist = center.distance_to(sat.position)
        if dist < nearest_dist:
            nearest_dist = dist
            nearest = sat
    select_satellite(nearest)


func _process(delta):
    emit_signal("satellite_summary", delta, state())

    for click in clicks:
        # This click was not eaten by a satellite
        if click.pressed:
            select_satellite(null)
            start_dragging(click)
        else:
            finish_dragging(click)
    clicks.clear()

    if selected_sat:
        var burn_fine = Input.is_action_pressed("burn_fine")
        if Input.is_action_pressed("burn_prograde"):
            selected_sat.burn(delta, true, burn_fine)
        elif Input.is_action_pressed("burn_retrograde"):
            selected_sat.burn(delta, false, burn_fine)

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
    
    if inactive_debris:
        inactive_debris = []
    

func handle_game_over():
    get_tree().change_scene('res://GameOver.tscn')
