extends Container

signal clicked;
signal finished;
signal entered;
signal exited;

var thing = {}

var disabled = true
var busy = false
var time_left = 0
var timer = null

func _ready():
    var btn = get_node("Background/Button")
    btn.connect("pressed", self, "clicked")
    btn.connect("mouse_entered", self, "entered")
    btn.connect("mouse_exited", self, "exited")
    get_node("Background/Cost").text = str(thing['cost']) + "btc"
    get_node("Background/Name").text = thing['display_name']
    get_node("Background/Button").hint_tooltip = description()
    get_node("Background/Sprite").texture = load("res://UI/" + thing.id + "_icon.png")


func _process(delta):
    var wipe = get_node("Background/Wipe")
    if busy:
        var percent = 1 - (timer.time_left / time_left)
        wipe.set_percent(percent * 100)

    wipe.visible = busy


func set_thing(x):
    thing = x


func set_enabled(enabled):
    var btn = get_node("Background/Button")
    btn.disabled = !enabled
    if btn.is_hovered():
        if disabled and enabled:
            emit_signal("entered")
        elif !disabled and !enabled:
            emit_signal("exited")
    disabled = !enabled


func clicked():
    if !busy:
        emit_signal("clicked")
        start_building()


func entered():
    if !disabled:
        emit_signal("entered")


func exited():
    emit_signal("exited")


func start_building():
    busy = true
    time_left = thing.build_time

    timer = Timer.new()
    timer.wait_time = time_left
    timer.connect("timeout", self, "finish_building")
    add_child(timer)
    timer.start()


func finish_building():
    busy = false
    remove_child(timer)
    timer = null
    emit_signal("finished")

    
func description():
    var usage
    var stats
    if thing.type == "fundraise":
        var c = global.FUNDRAISE_CONFIG[thing.id]
        usage = "Earn money when task completes."
        stats = 'Wait time: %d seconds\nIncome: Between %d and %d btc.' % [thing.build_time, c.raised_min, c.raised_max]
    elif thing.type == "satellite" or thing.type == "ark":
        var c = global.SHIP_CONFIG[thing.id]
        usage = "Launch satellite when task completes."
        stats = 'Build time: %d seconds\nStarting Income: %d btc/second.\nDelta-V: %d' % [thing.build_time, c.income, c.delta_v]
    elif thing.type == "laser":
        var c = global.LASER_CONFIG[thing.id]
        usage = 'Charge the lasers up so you can click the button and fire!'
        stats = 'Wait time: %d seconds\nLaser time set to: %d seconds' % [thing.build_time, c.time_earned]
    if thing.id == "ark":
        usage += "\nNavigate the Ark Away from the Earth and to safety!"
    return thing.description + '\n\n' + usage + '\n\n' + stats
