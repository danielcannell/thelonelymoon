extends Node


const GRAVITY = 0.1


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


func integrate_orbit(delta, pos, vel, massive_bodies):
    pos += vel * delta / 2
    vel += calculate_accel(pos, massive_bodies) * delta
    pos += vel * delta / 2
    return [pos, vel]


func predict_orbit(sat):
    var pos = sat.pos
    var vel = sat.vel
    
    var prev_theta = pos.angle()
    var theta = 0
    
    var massive_bodies = [get_node('../Earth')]
    
    var path = [global.metres_to_screen(pos)]

    for i in range(100):
        var delta = 0.2 / vel.length()
        var result = integrate_orbit(delta, pos, vel, massive_bodies)
        pos = result[0]
        vel = result[1]
        path.append(global.metres_to_screen(pos))
        
        var new_theta = pos.angle()
        var delta_theta = abs(new_theta - prev_theta)
        
        if delta_theta > PI:
            delta_theta = abs(delta_theta - 2*PI)
            
        theta += delta_theta
        prev_theta = new_theta
        
        if theta > 6:
            break
        
    return path


func _ready():
    pass


func _physics_process(delta):
    var massive_bodies = [get_node('../Moon'), get_node('../Earth')]
    var satellites = get_node('..').get_satellites()

    for s in satellites:
        var result = integrate_orbit(delta, s.pos, s.vel, massive_bodies)
        s.pos = result[0]
        s.vel = result[1]
#        var collision_info = s.move_and_collide(global.metres_to_screen(pos - s.pos))
#        if collision_info:
#            print("Collision!")
#            get_node("..").destroy_craft(s)
        