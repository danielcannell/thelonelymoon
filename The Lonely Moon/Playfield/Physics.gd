extends Node


const GRAVITY = 1


func vel_for_pos(pos):
    var speed = sqrt(GRAVITY * get_node('../Earth').MASS / pos.length())
    return speed * Vector2(pos.y, -pos.x).normalized()


func calculate_accel(pos, massive_bodies):
    var a = Vector2(0, 0)
    
    for b in massive_bodies:
        var offset = b.pos - pos
        var distance = offset.length()
        a += b.MASS * offset / pow(distance, 3)    
    
    return GRAVITY * a


func _ready():
    pass


func _physics_process(delta):
    var massive_bodies = [get_node('../Moon'), get_node('../Earth')]
    var satellites = get_node('..').get_satellites()

    for s in satellites:
        var vel = s.vel
        var pos = s.pos
        
        pos += vel * delta / 2
        vel += calculate_accel(pos, massive_bodies) * delta
        pos += vel * delta / 2

        s.vel = vel
        var collision_info = s.move_and_collide(global.metres_to_screen(pos - s.pos))
        if collision_info:
            print("Collision!")
            get_node("..").destroy_craft(s)
        