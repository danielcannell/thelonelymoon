extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

# "empty" or "launch_pending"
var state = "launch_pending";


func _ready():
    # Called when the node is added to the scene for the first time.
    # Initialization here
   self.ready_rocket()
    

#func _process(delta):
#    # Called every frame. Delta is time since last frame.
#    # Update game logic here.
#    pass

func ready_rocket():
    self.state = "launch_pending"
    self.get_node("payload_rocket").visible = true
    
func launch():
    self.state = "empty"
    self.get_node("payload_rocket").visible = false
