extends Button

signal select_skill(des)

var button_name = "Skill"
var cooldown = 0
var id = 0

func _ready():
	#position.y += 40 * id
	if cooldown > 0:
		disabled = true
		text = button_name + " - (" + str(cooldown) + ")"
	else:
		text = button_name
		

#func _process(delta):
	#pass


func _on_pressed():
	select_skill.emit(id)
