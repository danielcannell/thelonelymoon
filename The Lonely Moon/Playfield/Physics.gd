extends Node

const ATMOS_MIN = 0.18
const ATMOS_CUTOFF = 1.2
const GRAVITY = 0.1


func speed_for_alt(alt):
    return sqrt(GRAVITY * get_node('../Earth').MASS / alt)


func calculate_accel(pos, massive_bodies):
    var a = Vector2(0, 0)

    for b in massive_bodies:
        var offset = b.pos - pos
        var distance = offset.length()
        a += b.MASS * offset / pow(distance, 3)

    return GRAVITY * a


func atmospheric_drag(s, pos, vel):
    var earth = get_node('../Earth')
    var dist = (earth.pos - pos).length()

    if dist > ATMOS_CUTOFF:
        return Vector2(0, 0)
    if dist < ATMOS_MIN:
        dist = ATMOS_MIN

    var scale = s.config.drag_ratio * vel.length()

    # Compute drag in opposite direction to velocity
    var drag = - scale * 0.5 * exp((ATMOS_MIN - dist)/ATMOS_MIN) * vel
    return drag


func integrate_orbit(s, delta, pos, vel, massive_bodies):
    pos += vel * delta / 2
    vel += calculate_accel(pos, massive_bodies) * delta
    vel += atmospheric_drag(s, pos, vel) * delta
    pos += vel * delta / 2
    return [pos, vel]


func predict_orbit(sat):
    var pos = sat.pos
    var vel = sat.vel

    var prev_theta = pos.angle()
    var theta = 0

    var massive_bodies = [get_node('../Earth')]

    var path = [global.metres_to_screen(pos)]

    for i in range(200):
        var delta = min(0.2 / vel.length(), pos.length() / 4)
        var result = integrate_orbit(sat, delta, pos, vel, massive_bodies)
        pos = result[0]
        vel = result[1]

        var new_theta = pos.angle()
        var delta_theta = abs(new_theta - prev_theta)

        if delta_theta > PI:
            delta_theta = abs(delta_theta - 2*PI)

        theta += delta_theta
        prev_theta = new_theta

        if theta > 2*PI or pos.length() < 0.2:
            break

        path.append(global.metres_to_screen(pos))

    return path


func _ready():
    pass


func _physics_process(delta):
    var massive_bodies = [get_node('../Moon'), get_node('../Earth')]
    var satellites = get_node('..').get_satellites()

    for s in satellites:
        if s and s.active:
            var vel = s.vel if s.in_orbit else s.launch_trajectory()
            var result = integrate_orbit(s, delta, s.pos, vel, massive_bodies)
            # s.pos = result[0]
            s.vel = result[1]

            if s.type == "debris":
                s.pos = result[0]
                continue

            var collision_info = s.move_and_collide_metres(result[0] - s.pos)

            if collision_info:
                if collision_info.collider.type == "earth":
                    get_node("..").earth_collision(s)
                else:
                    get_node("..").craft_collision(s, collision_info.collider)

