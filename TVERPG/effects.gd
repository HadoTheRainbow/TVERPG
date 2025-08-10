extends Character_cust
class_name EffectList

var effect_name
var effect_instances = []

var linked_entity

func add_effect_instance(value, duration):
	effect_instances.append([value, duration])
	
func clear_effect():
	effect_instances = []

func resolve_effect():
	for i in effect_instances:
		activate_effect(i[0])
		if i[1] == 0:
			effect_instances.erase(i)
		else:
			i[1] -= 1
	
func activate_effect(value):
	pass

func damage(value, type):
	take_damage(value, type)

class AttackUp:
	extends EffectList
	func _init():
		effect_name = "AttackUp"
	func activate_effect(value):
		update_attack(value, false)
		
class Poison:
	extends EffectList
	func _init():
		effect_name = "Poison"
	func activate_effect(value):
		_damage(value, 3)

class Stun:
	extends EffectList
	func _init():
		effect_name = ""
	func activate_effect(value):
		disabled = true
	func clear_effect():
		disabled = false
	func resolve_effect():
		for i in effect_instances:
			activate_effect(i[0])
			if i[1] == 0:
				effect_instances.erase(i)
				disabled = false
			else:
				i[1] -= 1
				
class Unraveling:
	extends EffectList
	func _init():
		effect_name = "Unraveling"
	func activate_effect(value):
		_damage(value, 3)
		
class OnFire:
	extends EffectList
	func _init():
		effect_name = "OnFire"
	func activate_effect(value):
		_damage(value, 3)
