extends VBoxContainer

signal spawn_satellite

export (PackedScene) var shop_item

var shop_items = []


func _ready():
    get_node("Economy").connect("update_balance", self, "set_money")

    # Create buttons from config
    for x in global.MENU_CONFIG:
        var btn = shop_item.instance()
        btn.connect("clicked", self, "btn_click", [btn])
        btn.set_thing(x)
        shop_items.append(btn)
        get_node("Shop/Background/Container/Tiles").add_child(btn)

    set_money(0)


func btn_click(btn):
    var thing = btn.thing
    var type = thing.type
    var id = thing.id
    if type == "satellite":
        make_satellite(id)
    elif type == "fundraise":
        make_fundraise(id)


func make_satellite(id):
    emit_signal("spawn_satellite", id)


func make_fundraise(id):
    get_node("Economy").make_fundraise(id)


func set_money(amt):
    get_node("Money/Background/Labels/Amount").text = str(floor(amt))

    # Disable buttons based on cost
    for item in shop_items:
        item.set_enabled(item.thing.cost <= amt)


func _on_Playfield_satellite_summary(delta, state):
    get_node("Economy").receive_state(delta, state)
