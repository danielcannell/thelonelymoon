extends VBoxContainer

export (PackedScene) var notification_template;

var notifications = []

func add_notification(text):
    var n = notification_template.instance()
    n.set_text(text)
    add_child(n)
    var timer = Timer.new()
    timer.wait_time = 3
    timer.connect("timeout", self, "pop_notification")
    n.add_child(timer)
    add_child(n)
    notifications.append(n)
    timer.start()


func pop_notification():
    var n = notifications.pop_front()
    remove_child(n)