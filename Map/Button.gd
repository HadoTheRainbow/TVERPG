extends Control
@onready var button = $"."
@onready var button1 = $Button

@onready var popup_menu = $Button/PopupMenu
@export var Chapter : int
var Scenes =["res://Battle/battle_scene.tscn",]

func _on_popup_menu_id_pressed(id): 
	match id:
		0: get_tree().change_scene_to_file("res://Battle/battle_scene.tscn")
		1: print("nah")

var x : float = 340.0 * scale.y


func _ready():
	popup_menu.position.x = button.position.x * scale.x
	popup_menu.position.y = button.position.y + (340.0*scale.y)
	popup_menu.size.x = button1.size.x * scale.x
	popup_menu.size.y = button1.size.y * scale.y
	popup_menu.set("theme_override_font_sizes/font_size", button1.get("theme_override_font_sizes/font_size")*scale.x)
func _on_button_toggled(toggled_on):
	if toggled_on == true:
		popup_menu.show()

func _on_popup_menu_popup_hide():
	button1.toggle_mode
