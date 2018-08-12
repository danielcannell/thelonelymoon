extends Node2D

export (bool) var filled = true

var alt_max = 0
var alt_min = 0

const green = Color(0.1, 0.8, 0.1, 0.2)
const white = Color(1, 1, 1, 1)


func set_range(alt_min, alt_max):
    self.alt_min = alt_min
    self.alt_max = alt_max
    
    update()


func draw_filled(color):
    var num_points = 50
    var points = PoolVector2Array()
    
    for i in range(num_points):
        var theta = 2 * PI * i / (num_points - 1)
        var point = alt_max * Vector2(sin(theta), cos(theta))
        points.push_back(point)
        
    for i in range(num_points):
        var theta = -2 * PI * i / (num_points - 1)
        var point = alt_min * Vector2(sin(theta), cos(theta))
        points.push_back(point)

    draw_colored_polygon(points, color)


func draw_dotted_circle(radius, segment_length, color):
    var circumference = 2 * PI * radius
    # Compute the best even-numbered segment count
    var num_segments = (int(circumference / (segment_length*2)) / 2) * 2
    var num_points = num_segments + 1
    var points = PoolVector2Array()

    for i in range(num_points):
        var theta = 2 * PI * i / (num_points - 1)
        var point = radius * Vector2(sin(theta), cos(theta))
        points.push_back(point)

    var on = true
    for i in range(num_points-1):
        if on:
            draw_line(points[i], points[i+1], color)
        on = not on


func draw_unfilled(color):
    draw_dotted_circle(alt_min, 5, color)
    draw_dotted_circle(alt_max, 5, color)


func _draw():
    if filled:
        draw_filled(green)
    else:
        draw_unfilled(white)
    

func _ready():
    pass
