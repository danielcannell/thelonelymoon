extends Node


const GRAVITY = 1e6


func calculate_accel(s, massive_bodies):
    var a = Vector2(0, 0)
    
    for b in massive_bodies:
        var offset = b.position - s.position
        var distance = offset.length()
        a += offset / pow(distance, 3)    
    
    return GRAVITY * a


func _ready():
    pass


func _process(delta):
    var massive_bodies = [get_node('../Moon'), get_node('../Earth')]
    var satellites = get_node('..').get_satellites()
    
    for s in satellites:
        var pos = s.position
        var vel = s.velocity
        var a = calculate_accel(s, massive_bodies)
        vel += a * delta
        pos += vel * delta
        s.velocity = vel
        s.position = pos