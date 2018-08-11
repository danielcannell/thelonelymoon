extends VBoxContainer

signal on_purchase;

export (PackedScene) var shop_item

var shop_items = []

func _ready():
    # Create buttons from config
    for x in global.MENU_CONFIG:
        var btn = shop_item.instance()
        btn.connect("click", self, "btn_click", [btn])
        shop_items.append(btn)
        get_node("Shop/Background/Container/Tiles").add_child(btn)

    set_money(0)


func btn_click(btn):
    print(btn)


func set_money(x):
    get_node("Money/Background/Labels/Amount").text = str(x)

    # TODO: disable buttons based on cost

