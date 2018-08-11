extends VBoxContainer

export (PackedScene) var notification_template

func add_notification(text):
    var n = notification_template.instance()
    n.set_text(text)
    add_child(n)
    var timer = Timer.new()
    timer.wait_time = 5
    timer.connect("timeout", self, "pop_notification", [n])
    n.add_child(timer)
    timer.start()


func pop_notification(n):
    remove_child(n)
