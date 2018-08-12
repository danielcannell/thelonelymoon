extends Container

const texture_good = preload("res://UI/bg_green.png")
const texture_bad = preload("res://UI/bg_red.png")


func set_text(text):
    get_node("Background/Label").text = text


func set_type(type):
    var bg = get_node("Background")
    if type == global.NOTIFICATION_TYPE.GOOD:
        bg.texture = texture_good
    elif type == global.NOTIFICATION_TYPE.BAD:
        bg.texture = texture_bad
