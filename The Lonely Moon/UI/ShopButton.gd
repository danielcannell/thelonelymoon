extends Container

signal clicked;
signal finished;

var thing = {}

var busy = false
var time_left = 0
var timer = null

func _ready():
    get_node("Background/Button").connect("pressed", self, "clicked")
    get_node("Background/Cost").text = str(thing['cost']) + "btc"
    get_node("Background/Name").text = thing['display_name']
    get_node("Background/Button").hint_tooltip = thing['description']


func _process(delta):
    if busy:
        var percent = 1 - (timer.time_left / time_left)
        get_node("Background/Wipe").set_percent(percent * 100)

    get_node("Background/Wipe").visible = busy


func set_thing(x):
    thing = x


func set_enabled(enabled):
    if !busy:
        get_node("Background/Button").disabled = !enabled


func clicked():
    if !busy:
        emit_signal("clicked")
        start_building()


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
