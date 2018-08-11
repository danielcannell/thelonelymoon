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
                var new_scale = get_node("Game").scale.x * 1.1
                new_scale = min(new_scale, 8.0)

                var g = get_node("Game")
                g.scale.x = new_scale
                g.scale.y = new_scale

            # zoom out
            if event.button_index == BUTTON_WHEEL_DOWN:
                var new_scale = get_node("Game").scale.x * 0.9
                new_scale = max(new_scale, 0.05)

                var g = get_node("Game")
                g.scale.x = new_scale
                g.scale.y = new_scale