extends VBoxContainer

signal on_purchase;

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
    print(btn)


func set_money(x):
    get_node("Money/Background/Labels/Amount").text = str(floor(x))

    # TODO: disable buttons based on cost



func _on_Playfield_satellite_summary(delta, state):
    get_node("Economy").receive_state(delta, state)
