extends Node2D

signal missile_pending
signal missile_launched

signal notify

var state = "empty"

var man_timer = null
var launch_timer = null


func _ready():
    self.get_node("missile").visible = false
    self.man_timer = self.get_node("AngryManTimer")
    self.man_timer.one_shot = true
    self.man_timer.wait_time = 180

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

func _on_craft_destroyed(craft):
    if craft.type == "missile":
        self.man_timer.start()

func _on_craft_collision(craft1, craft2):
    var target
    if craft1.type == "missile":
        target = craft2
    elif craft2.type == "missile":
        target = craft1
    else:
        return

    if target.type != "debris":
        emit_signal("notify", "'Supremely Evil Leader' laughs at your patheic %s" % global.id_display_lookup[target.type], global.NOTIFICATION_TYPE.BAD)

func place_missile():
    self.state = "launch_pending"
    self.get_node("missile").visible = true
    emit_signal("missile_pending")
    emit_signal("notify", "'Supremely Evil Leader' is displeased - PREPPING MISSILE!", global.NOTIFICATION_TYPE.BAD)
    
    
func launch_missile():
    self.state = "empty"
    self.get_node("missile").visible = false
    emit_signal("notify", "MISSLE LAUNCHED! His Evilness watches", global.NOTIFICATION_TYPE.BAD)
    emit_signal("missile_launched")
