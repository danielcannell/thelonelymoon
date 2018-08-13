extends Container

signal spawn_satellite
signal charge_laser
signal show_satellite_range
signal hide_satellite_range
signal satellite_building

export (PackedScene) var shop_item

var shop_items = []


func _ready():
    get_node("Economy").connect("update_balance", self, "set_money")
    get_node("../../Playfield").connect("notify", self, "create_notification")
    get_node("../../Playfield/Earth/EvilSpaceCenter").connect("notify", self, "create_notification")

    # Create buttons from config
    for x in global.MENU_CONFIG:
        var btn = shop_item.instance()
        btn.connect("clicked", self, "btn_clicked", [btn])
        btn.connect("finished", self, "btn_finished", [btn])
        btn.connect("entered", self, "btn_entered", [btn])
        btn.connect("exited", self, "btn_exited", [btn])
        btn.set_thing(x)
        shop_items.append(btn)
        get_node("Shop/Shop/Background/Container/Tiles").add_child(btn)

    set_money(0)


func create_notification(text, type):
    get_node("Notifications").add_notification(text, type)


func btn_clicked(btn):
    var thing = btn.thing
    var cost = thing.cost
    get_node("Economy").spend_money(cost)
    btn.get_node("IssueBuild").play()

    if thing.type == "satellite":
        emit_signal("satellite_building", thing.id)


func btn_finished(btn):
    var thing = btn.thing
    var type = thing.type
    var id = thing.id

    if type == "satellite":
        make_satellite(id, thing.display_name)
    elif type == "fundraise":
        btn.get_node("MoneyArrival").play()
        make_fundraise(id)
    elif type == "laser":
        make_laser()


func btn_entered(btn):
    var thing = btn.thing
    if thing.type == "satellite":
        emit_signal("show_satellite_range", thing.id)


func btn_exited(btn):
    emit_signal("hide_satellite_range")


func make_satellite(id, name):
    emit_signal("spawn_satellite", id)
    create_notification(name + " launched!", global.NOTIFICATION_TYPE.GOOD)


func make_fundraise(id):
    get_node("Economy").make_fundraise(id)


func make_laser():
    emit_signal("charge_laser")
    create_notification("Laser recharged!", global.NOTIFICATION_TYPE.GOOD)


func set_money(amt):
    get_node("Shop/Money/Background/Labels/Amount").text = str(floor(amt))

    # Disable buttons based on cost
    for item in shop_items:
        item.set_enabled(item.thing.cost <= amt)


func _on_Playfield_satellite_summary(delta, state):
    var satellites = state[0]
    var debris_count = state[1]
    var moon_state = state[2]
    get_node("Economy").receive_state(delta, satellites)
    get_node("StatsPanel").update_stats(delta, satellites, debris_count, moon_state)


func on_satellite_selected(sat):
    get_node("SatInfo").on_satellite_selected(sat)


func on_showstats_toggled(button_pressed):
    get_node("StatsPanel").visible = button_pressed
