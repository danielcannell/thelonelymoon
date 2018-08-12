extends Node2D

var state = "launch_pending"
var building_satellites = {}



func _ready():
   self.remove_rocket()


func _on_satellite_building(id):
    building_satellites[id] = null
    self.place_rocket()

func _on_satellite_built(id):
    building_satellites.erase(id)
    if self.building_satellites.size() == 0:
        self.remove_rocket()
    get_node("LaunchSound").play()
        

func place_rocket():
    self.state = "launch_pending"
    self.get_node("payload_rocket").visible = true
    
func remove_rocket():
    self.state = "empty"
    self.get_node("payload_rocket").visible = false
