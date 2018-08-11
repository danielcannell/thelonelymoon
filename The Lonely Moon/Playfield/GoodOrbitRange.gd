extends Node2D

var alt_max = 0
var alt_min = 0


func set_range(alt_min, alt_max):
    self.alt_min = alt_min
    self.alt_max = alt_max
    
    update()


func _draw():
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
        
    draw_colored_polygon(points, Color(0.1, 0.8, 0.1, 0.2))
    

func _ready():
    pass
