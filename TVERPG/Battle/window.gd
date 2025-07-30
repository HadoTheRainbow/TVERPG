class_name battle_window extends Container

signal button_focused(button: BaseButton)
signal button_pressed(button: BaseButton)

var index: int = 0

func ready() -> void:
	for button in get_buttons():
		button.focus_entered.connect(_on_Button_focused.bind(button))
		button.pressed.connect(_on_Button_pressed.bind(button))

func get_buttons() -> Array:
	return get_children()

func connect_to_buttons(target: Object, _name: String = name) -> void:
	var callable: Callable = Callable()
	callable = Callable(target, "_on_" + _name + "_focused")
	button_focused.connect(callable)
	callable = Callable(target, "_on_" + _name + "_pressed")
	button_pressed.connect(callable)
	

func button_focus(n: int = index) -> void:
	var button: BaseButton = get_buttons()[n]
	button.grab_focus()

func _on_Button_focused(button: BaseButton) -> void:
	emit_signal("button_focused", button)
		
func _on_Button_pressed(button: BaseButton) -> void:
	emit_signal("button_pressed", button) 
