extends Node2D

const color = Color(0, 1, 0, 1)

var pos = Vector2()
var size = Vector2(50, 50)

func _draw():
    draw_rect(Rect2(pos - size/2, size), color, false)


func place(p):
    pos = p
    update()


func _process(delta):
    var scale = global.current_scale()
    size = Vector2(50, 50)
    if scale > 3:
        size *= (scale / 3)


func _ready():
    pass
