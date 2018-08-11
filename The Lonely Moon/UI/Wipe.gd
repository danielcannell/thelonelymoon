extends Control

var percent = 100

const npoints = 32
const red = Color(1.0, 1.0, 1.0, 0.25)


func _draw_pie(center, angle, radius, color):
    var points = PoolVector2Array()
    
    points.push_back(center)
    
    for i in range(npoints+1):
        var d = (i/float(npoints)) * angle - 90
        var angle_point = deg2rad(d)
        points.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)

    points.push_back(center)

    draw_colored_polygon(points, color, PoolVector2Array(), null, null, true)


func _draw():
    var radius = (self.rect_size.x / 2) - 4
    _draw_pie(self.rect_size / 2, (percent / 100.0) * 360.0, radius, red)


func _process(delta):
    update()

func set_percent(x):
    percent = x
    update()