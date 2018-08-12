extends Node2D

var state = "empty"


func _ready():
   self.remove_missile()


func place_missile():
    self.state = "launch_pending"
    self.get_node("missile").visible = true
    
func remove_missile():
    self.state = "empty"
    self.get_node("missile").visible = false
