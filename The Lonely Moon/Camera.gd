extends Camera2D

func update_zoom(ratio):
    var new_scale = self.zoom.x * ratio
    new_scale = min(new_scale, 8.0)
    new_scale = max(new_scale, 0.1)
    self.zoom.x = new_scale
    self.zoom.y = new_scale
    
    # Keep the earth's position fixed relative to the centre of the viewport
    self.offset.x = -100 * new_scale

func _input(event):
    if event is InputEventMouseButton:
        if event.is_pressed():
            # zoom in
            if event.button_index == BUTTON_WHEEL_UP:
                update_zoom(0.9)

            # zoom out
            if event.button_index == BUTTON_WHEEL_DOWN:
                update_zoom(1.1)
                