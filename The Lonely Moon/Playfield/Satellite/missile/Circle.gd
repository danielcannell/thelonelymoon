extends Node2D

const color = Color(1, 0, 0, 1)

export (float) var radius = 10

func _draw():
    var points = PoolVector2Array()
    var num_points = 33

    for i in range(num_points):
        var theta = 2 * PI * i / (num_points - 1)
        var point = radius * Vector2(sin(theta), cos(theta))
        points.push_back(point)

    var on = true
    for i in range(num_points-1):
        if on:
            draw_line(points[i], points[i+1], color)
        on = not on
