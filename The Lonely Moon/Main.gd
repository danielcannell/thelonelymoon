extends Node

func _ready():
    var ui = get_node("UiLayer/UI")
    var space_center = get_node("Playfield/Earth/SpaceCenter")

    ui.connect("satellite_building", space_center, "_on_satellite_building")
    ui.connect("spawn_satellite", space_center, "_on_satellite_built")

    var playfield = get_node("Playfield")
    var evil_space_center = get_node("Playfield/Earth/EvilSpaceCenter")
    evil_space_center.connect("missile_pending", playfield, "_on_missile_pending")
    evil_space_center.connect("missile_launched", playfield, "_on_missile_launched")
    playfield.connect("craft_collision", evil_space_center, "_on_craft_collision")
    playfield.connect("craft_destroyed", evil_space_center, "_on_craft_destroyed")

    ui.connect("charge_laser", playfield, "charge_laser")
    ui.connect("hide_satellite_range", playfield, "hide_satellite_range")
    ui.connect("show_satellite_range", playfield, "show_satellite_range")
    ui.connect("spawn_satellite", playfield, "new_craft")

    playfield.connect("satellite_selected", ui, "on_satellite_selected")
    playfield.connect("satellite_summary", ui, "on_satellite_summary")
