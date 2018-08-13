extends Node

var show = false


func _ready():
    get_node("ShowStory").connect("pressed", self, "_show_story_pressed")
    get_node("BeginButton").connect("pressed", self, "_begin_pressed")
    

func _show_story_pressed():
    show = !show
    if show:
        get_node("Storybox").show()
        get_node("ShowStory").text = "Hide story"
    else:
        get_node("Storybox").hide()
        get_node("ShowStory").text = "Show story"
    

func _begin_pressed():
    get_tree().change_scene("res://Main.tscn")
    self.hide()
