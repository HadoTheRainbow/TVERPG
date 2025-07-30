extends Node

class_name Character_cust


var id: int
var lvl: int
var char_name: String
var hp: int
var max_hp: int
var attack: int
var defense: int
var speed: int
var magic: int
var status_effects: Array = []
var is_hero: bool
var resistances = [1,1,1,1,1,1,1,1,1,1,1,1]
var default_normal_type = 0
var type_override = -1
var skills = []

var stats_reference = {
	"hp": hp,
	"attack": attack,
	"defense": defense,
	"speed": speed,
	
	
	
}

var skill_types = {
	"DAMAGE": false, #priority 1
	"HEAL" : false, #priority 2
	"BUFF" : false, #priority 5
	"DEBUFF" : false, #priority 4
	"HEAVY" : false, #priority 3
	"SPECIAL" : false, #priority 0
	"ALT HEAL" : false, #priority 2
	
}

func _init(data: Array):
	if data.size() >= 5:
		char_name = str(data[0])
		max_hp = data[1]
		hp = max_hp
		attack = data[2]
		defense = data[3]
		speed = data[4]
		magic = data[5]
func reload():
	char_name = char_name
	max_hp = apply_level(max_hp, lvl, 1.1)
	hp = max_hp
	attack = apply_level(attack, lvl, 1.1)
	defense = apply_level(defense, lvl, 1.1)
	speed = speed
	magic = magic
	
func get_stat(a):
	stats_reference = {
	"hp": hp,
	"attack": attack,
	"defense": defense,
	"speed": speed,
	
	
	}
	return stats_reference[a]

func apply_level(value,level,level_scaling) -> int:
	return int(value*(level_scaling**(level-1)))
func is_alive() -> bool:
	return hp > 0
func update_value():
	pass
	
func take_damage(damage: int, damage_type: int):
	if is_alive():
		var actual_damage = max(1, (damage - defense))
		#var actual_damage = max(1, damage * (2.718**(-(defense/(225+lvl * 4))) + 0.01 * lvl))
		actual_damage = max(0, actual_damage * resistances[damage_type])
		hp = max(0, hp - int(actual_damage))
		return int(actual_damage)
	return false
func print_hp(hp):
	print(hp)
	
func heal(amount: int):
	var old_hp = hp
	hp = min(max_hp, hp + amount)
	if hp == max_hp:
		return "MAX"
	else:
		return hp - old_hp
	
	
	
	
	
class SkeletonGeneric:
	extends Character_cust
	
	
	func _init():
		id = 0
		char_name = "Skeleton"
		hp = 30
		max_hp = 30
		attack = 4
		defense = 11
		speed = 14
		magic = 2
		status_effects = []
		resistances[1] = 1.20
		resistances[7] = 1.20
		resistances[3] = 0.50
		hp = max_hp
		
class FireSlime:
	extends Character_cust
	
	
	func _init():
		id = 0
		char_name = "Fire Slime"
		hp = 20
		max_hp = 20
		attack = 4
		defense = 7
		speed = 16
		magic = 2
		status_effects = []
		resistances[1] = -99.00
		resistances[2] = 2.00
		max_hp = max_hp
		hp = max_hp
		type_override = 1
		skills = [
			"Gelfire"
			
			
		]
		
		
class StormPrincess:
	extends Character_cust
	
	
	func _init():
		id = 0
		char_name = "Storm Princess"
		hp = 120
		max_hp = 120
		attack = 38
		defense = 15
		speed = 46
		magic = 21
		status_effects = []
		for i in resistances.size():
			resistances[i] = -99.00
		max_hp = max_hp
		hp = max_hp
		type_override = 12
