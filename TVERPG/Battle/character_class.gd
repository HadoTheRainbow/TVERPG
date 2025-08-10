extends CharacterEntity

class_name Character_cust

var skill_name_dict = SkillsDict.new()


var connector

var ent_id: int
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
var armor_pierce: int

var character_downed = false
var character_disabled = false

var default_values = []

var hit_rate_mod
var crit_rate_mod
var crit_damage_mod
var effect_hit_rate_mod
var effect_duration_mod



var resistances = [1,1,1,1,1,1,1,1,1,1,1,1]
var default_normal_type = 0
var type_override = -1
var skills = [
	skill_name_dict.character_list["Normal"], 
	skill_name_dict.character_list["Special"], 
	skill_name_dict.character_list["Hit"], 
	skill_name_dict.character_list["FlameBlade"], 
	skill_name_dict.character_list["Heal"]
	]

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
	skill_name_dict.connector = self
	char_name = char_name
	max_hp = apply_level(max_hp, lvl, 1.1)
	hp = max_hp
	attack = apply_level(attack, lvl, 1.1)
	defense = apply_level(defense, lvl, 1.1)
	speed = speed
	magic = apply_level(magic, lvl, 1.1)
	
	default_values = [max_hp, attack, defense, speed, magic]
	
	
func get_stat(a):
	stats_reference = {
	"hp": hp,
	"attack": attack,
	"defense": defense,
	"speed": speed,
	
	
	}
	print(a)
	return stats_reference[a]
	
	
func get_all_attack_stats():
	return [char_name, max_hp, attack, defense, speed, magic]

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

func update_attack(value, multiplicative):
	if multiplicative:
		attack *= value
	else:
		attack += value

func update_defense(value, multiplicative):
	if multiplicative:
		defense *= value
	else:
		defense += value

func update_speed(value, multiplicative):
	if multiplicative:
		speed *= value
	else:
		speed += value

func update_magic(value, multiplicative):
	if multiplicative:
		magic *= value
	else:
		magic += value

func update_hit_rate(value, multiplicative):
	if multiplicative:
		hit_rate_mod *= value
	else:
		hit_rate_mod += value

func update_crit_rate(value, multiplicative):
	if multiplicative:
		crit_rate_mod *= value
	else:
		crit_rate_mod += value

func update_crit_damage(value, multiplicative):
	if multiplicative:
		crit_damage_mod *= value
	else:
		crit_damage_mod += value

func update_effect_hit_rate(value, multiplicative):
	if multiplicative:
		effect_hit_rate_mod *= value
	else:
		effect_hit_rate_mod += value

func update_effect_duration(value, multiplicative):
	if multiplicative:
		hit_rate_mod *= value
	else:
		hit_rate_mod += value


class Kat:
	extends Character_cust
	
	
	func _init():
		id = 0
		char_name = "Kat"
		hp = 74
		max_hp = 74
		attack = 27
		defense = 7
		speed = 16
		magic = 24
		status_effects = []
		resistances[0] = 0.80
		resistances[4] = 1.20
		skills = [
			skill_name_dict.character_list["Normal"], 
			skill_name_dict.character_list["Overclock"], 
			skill_name_dict.character_list["Hit"], 
			skill_name_dict.character_list["DualStrike"], 
			skill_name_dict.character_list["Blaze"], 
			
		]
	
class SkeletonGeneric:
	extends Character_cust
	
	
	func _init():
		id = 0
		char_name = "Skeleton"
		hp = 60
		max_hp = 60
		attack = 18
		defense = 6
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
		hp = 45
		max_hp = 45
		attack = 12
		defense = 2
		speed = 16
		magic = 2
		status_effects = []
		resistances[1] = -99.00
		resistances[2] = 2.00
		type_override = 1
		skills = [
			skill_name_dict.character_list["Normal"], 
			skill_name_dict.character_list["Blaze"], 
			skill_name_dict.character_list["FlameBlade"], 
			
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
			resistances[i] = 0.50
		type_override = 12
		skills = [
			skill_name_dict.character_list["Normal"], 
			skill_name_dict.character_list["InfinitePain"], 
			skill_name_dict.character_list["Blaze"], 
			skill_name_dict.character_list["Heal"], 
			skill_name_dict.character_list["DualStrike"], 
			skill_name_dict.character_list["Fury"], 
			
		]
