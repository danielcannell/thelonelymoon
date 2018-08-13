extends "res://Playfield/Satellite/Satellite.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
const type = "cleanup_sat"

onready var laser = get_node("Laser")
onready var barrel = get_node("Barrel")
var laser_on = false
var laser_phase = 0


func _on_laser_entered(body):
    if body != self:
        get_node("..").no_debris_collision(body, 'a laser')


func _ready():
    laser.connect("body_entered", self, "_on_laser_entered")
    laser.get_node("Sound").connect("finished", self, "_laser_sound_loop")


func turn_on_laser():
    laser.visible = true
    laser.monitoring = true
    laser_on = true
    get_node("Laser/Sound").play()


func turn_off_laser():
    laser.visible = false
    laser.monitoring = false
    laser_on = false
    get_node("Laser/Sound").stop()
    
    
func _laser_sound_loop():
    laser.get_node("Sound").play()


func _process(delta):
    laser_phase += 5 * delta
    if laser_phase > 2 * PI:
        laser_phase -= 2 * PI

    laser.rotation = laser_phase
    barrel.rotation = laser_phase

    if selected and not laser_on and Input.is_action_pressed("lasers"):
        turn_on_laser()
    elif laser_on and not selected or not Input.is_action_pressed("lasers"):
        turn_off_laser()
