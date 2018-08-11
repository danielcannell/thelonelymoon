extends MarginContainer

var curr_sat = null

func _ready():
    # Called when the node is added to the scene for the first time.
    # Initialization here
    pass

func _process(delta):
    # Called every frame. Delta is time since last frame.
    # Update game logic here.
    if curr_sat != null:
        get_node("Background/Container/HBoxContainer2/TypeVal").text = "TBD1"
        get_node("Background/Container/HBoxContainer/FuelVal").text = "TBD2"

func on_satellite_selected(sat):
    curr_sat = sat
    
    if curr_sat != null:
        self.visible = true
    else:
        self.visible = false
