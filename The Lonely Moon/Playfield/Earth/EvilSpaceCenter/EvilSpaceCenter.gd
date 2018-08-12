extends Node2D

signal missile_pending
signal missile_launched

var state = "empty"

var man_timer = null
var launch_timer = null


func _ready():
    self.get_node("missile").visible = false
    self.man_timer = self.get_node("AngryManTimer")
    self.man_timer.wait_time = 60

    self.launch_timer = self.get_node("LaunchTimer")
    self.launch_timer.one_shot = true
    self.launch_timer.wait_time = 10

    self.man_timer.connect("timeout",self,"_on_angry_man_timeout")
    self.launch_timer.connect("timeout", self, "_on_launch_timeout")

    self.man_timer.start()
    
func _on_angry_man_timeout():
    self.place_missile()
    self.launch_timer.start()
    
func _on_launch_timeout():
    self.launch_missile()

func place_missile():
    self.state = "launch_pending"
    self.get_node("missile").visible = true
    emit_signal("missile_pending")
    
func launch_missile():
    self.state = "empty"
    self.get_node("missile").visible = false
    emit_signal("missile_launched")
