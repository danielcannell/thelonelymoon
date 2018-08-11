extends Node


const GRAVITY = 1


func vel_for_pos(pos):
    var speed = sqrt(GRAVITY * get_node('../Earth').MASS / pos.length())
    return speed * Vector2(pos.y, -pos.x).normalized()


func calculate_accel(s, massive_bodies):
    var a = Vector2(0, 0)
    
    for b in massive_bodies:
        var offset = b.pos - s.pos
        var distance = offset.length()
        a += offset / pow(distance, 3)    
    
    return GRAVITY * a


func _ready():
    pass


func _process(delta):
    var massive_bodies = [get_node('../Moon'), get_node('../Earth')]
    var satellites = get_node('..').get_satellites()

    for s in satellites:
        var a = calculate_accel(s, massive_bodies)
        s.vel += a * delta
        s.pos += s.vel * delta