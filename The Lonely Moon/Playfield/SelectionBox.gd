extends Node2D

var drag_start = Vector2(0, 0)
var drag_end = Vector2(0, 0)

const color = Color(0, 1, 0, 1)

func _draw():
    draw_rect(Rect2(drag_start, drag_end - drag_start), color, false)


func _process(delta):
    var shape = get_node("Shape")
    # Update collision area size
    shape.shape.set_extents((drag_end - drag_start) / 2)
    # Update collision area position
    shape.set_position((drag_start + drag_end) / 2)


func set_drag_start(pos):
    drag_start = pos
    update()


func set_drag_end(pos):
    drag_end = pos
    update()


func get_satellites_contained():
    var sats = []
    for s in get_overlapping_bodies():
        if "Satellite" in s.name:
            sats.append(s)
    return sats

func get_center():
    return (drag_start + drag_end) / 2
