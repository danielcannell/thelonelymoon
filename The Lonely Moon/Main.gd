extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
    # Called when the node is added to the scene for the first time.
    # Initialization here
    pass

#func _process(delta):
#    # Called every frame. Delta is time since last frame.
#    # Update game logic here.
#    pass

func _input(event):
    if event is InputEventMouseButton:
        if event.is_pressed():
            # zoom in
            if event.button_index == BUTTON_WHEEL_UP:
                get_node("Game").scale *= 1.1
            # zoom out
            if event.button_index == BUTTON_WHEEL_DOWN:
                get_node("Game").scale *= 0.9