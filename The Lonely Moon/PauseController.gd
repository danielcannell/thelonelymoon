extends Node

var paused = false;


func _ready():
    get_node("PauseMenu/ResumeButton").connect("button_up", self, "unpause")
    get_node("PauseMenu/RestartButton").connect("button_up", self, "_restart_confirm")


func _toggle_pause():
    paused = !paused
    get_tree().paused = paused
    get_node("PauseMenu").visible = paused


func pause():
    if paused:
        return
    else:
        _toggle_pause()

  
func unpause():
    if !paused:
        return
    else:
        _toggle_pause()


func _input(ev):
    if ev is InputEventKey and ev.scancode == KEY_P and !ev.pressed:
        _toggle_pause()


func _restart_confirm():
    # TODO: This should show a dialog confirming that you want to restart.
    # For now, just restart.
    get_tree().change_scene('res://Main.tscn')
    unpause()