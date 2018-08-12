extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
    # Called when the node is added to the scene for the first time.
    # Initialization here
    var ui = get_node("UiLayer/UI")
    var space_center = get_node("Playfield/Earth/SpaceCenter")
    print(ui, space_center)
    ui.connect("satellite_building", space_center, "_on_satellite_building")
    ui.connect("spawn_satellite", space_center, "_on_satellite_built")

#func _process(delta):
#    # Called every frame. Delta is time since last frame.
#    # Update game logic here.
#    pass
