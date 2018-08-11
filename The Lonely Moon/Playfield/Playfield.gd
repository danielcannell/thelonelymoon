extends Container


const GRAVITY = 1e8


func calculate_accel(pos):
    var distance = pos.length()
    return GRAVITY * -pos / pow(distance, 3)


func _ready():
    pass


func _process(delta):
    var satellites = [
        get_node("Satellite1"),
        get_node("Satellite2"),
        get_node("Satellite3"),
    ]
    
    for s in satellites:
        var pos = s.position
        var vel = s.velocity
        var a = calculate_accel(pos)
        vel += a * delta
        pos += vel * delta
        s.position = pos
