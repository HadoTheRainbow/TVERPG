extends Node

signal spawned()

var count = 0

var enemy_node = preload("res://Battle/characters/character.tscn")
@onready var connect = load("res://Battle/battle_window.gd")

func _unhandled_key_input(event: InputEvent) -> void:
    var debugvar1: InputEventKey = event
    if event.is_pressed():
        var key: int = debugvar1.keycode
        match key:
            KEY_R:
                get_tree().reload_current_scene()
            KEY_Q:
                get_tree().quit()
            KEY_1:
                print("Hello World")
            KEY_X:
                pass
                #spawned.emit()
                #print(connect.max_enemies)

                #connect.max_reset(count)
