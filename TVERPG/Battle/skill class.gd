extends CharacterEntity
class_name Skill

#DAMAGE TYPES
#physical = 0
#fire = 1
#water = 2
#poison = 3
#void = 4
#ice = 5
#sonic = 6
#radiant = 7
#soul = 8
#chromatic = 9
#divine = 10
#reality = 11

#TARGETTING TYPES
#single opp = 0
#single opp rand = 1
#all opp = 2
#single ally = 3
#single ally rand = 4
#all ally = 5
#all = 6
#self = 7
#custom = 8

#var rng = RandomNumberGenerator.new()

var skill_name: String
var value = 0
var attack_scale = 2
var damage_type = 0
var target_type = 0
var instances = 1
var repeats = 0
var effects = []
var export_effects = []
var cooldown = 0
var energy_remain = 0
var effect_scale_stat

var skill_owner

var hit_mod
var crit_mod
var crit_d_mod

#var character

func call_skill(stats):
	trigger_cooldown()
	if effects.size() == 0:
		return [int(value * stats[attack_scale]), damage_type]
	else:
		var arr = [value * stats[attack_scale], damage_type]
		export_effects = []
		for i in effects:
			var temp_var = roll_effect(i,0)
			if temp_var != null:
				export_effects.append(temp_var)
		if export_effects.size() > 0:
			arr.append(export_effects)
		print(arr)
		return arr
		
func roll_effect(data, modifier):
	if data[1] + modifier >= rng.randf_range(0.00, 1.00):
		return [data[0], data[2], data[3]]
	else:
		return 

func get_scaling_value(stat, modifier):
	print(skill_owner)
	if typeof(skill_owner) != TYPE_NIL:
		if typeof(skill_owner.get_stat(stat)) == TYPE_INT:
			return skill_owner.get_stat(stat) * modifier
	pass

func calculate_value():
	return 
	
func energy_change(v):
	energy_remain -= v
	if energy_remain < 0:
		energy_remain = 0
func trigger_cooldown():
	energy_remain = cooldown + 1
	
class Normal:
	extends Skill
	func _init(type, connection):
		skill_owner = connection
		skill_name = "Normal"
		value = 0.50
		attack_scale = 2
		damage_type = type
		effects = []
		

class FlameBlade:
	extends Skill
	func _init(connection):
		skill_owner = connection
		skill_name = "Flame Blade"
		value = 0.60
		attack_scale = 2
		damage_type = 1
		effects = []
		cooldown = 2
		
class VenomousBite:
	extends Skill
	func _init(connection):
		skill_owner = connection
		skill_name = "Venomous Bite"
		value = 0.60
		attack_scale = 2
		damage_type = 3
		effects = [["Poison", 1.00, 2, ]]
		cooldown = 5

class InfinitePain:
	extends Skill
	func _init(connection):
		skill_owner = connection
		skill_name = "Infinite Pain"
		value = 0.60
		attack_scale = 2
		damage_type = 1
		instances = 40
		effects = []
		cooldown = 2

class DefaultHit:
	extends Skill
	func _init(connection):
		skill_owner = connection
		skill_name = "Hit"
		value = 1.00
		attack_scale = 2
		damage_type = 0
		cooldown = 3
		
class DefaultSpecial:
	extends Skill
	func _init(connection):
		skill_owner = connection
		skill_name = "Special"
		value = rng.randf_range(0.60, 0.90)
		attack_scale = 2
		damage_type = 1
		instances = 3
		cooldown = 4


		
class DualStrike:
	extends Skill
	func _init(connection):
		skill_owner = connection
		skill_name = "Dual Strike"
		value = 0.40
		attack_scale = 2
		damage_type = 0
		instances = 2
		effects = []
		cooldown = 7
		
class BlindingSlash:
	extends Skill
	func _init(connection):
		skill_owner = connection
		skill_name = "Blinding Slash"
		value = 1.00
		attack_scale = 2
		damage_type = 7
		instances = 1
		effects = [["Stun", 0.50, 1, 0]]
		cooldown = 5

class DeepBreath:
	extends Skill
	func _init(connection):
		skill_owner = connection
		skill_name = "Deep Breath"
		value = 0.00
		attack_scale = 0
		damage_type = 0
		instances = 1
		effects = [["EffectRateUp", 999.00, 3, 0.05],["CritRateUp", 999.00, 3, 0.2],["HitRateUp", 999.00, 3, 0.5]]
		cooldown = 5

class Firecracker:
	extends Skill
	func _init(connection):
		skill_owner = connection
		skill_name = "Firecracker"
		value = 0.40
		attack_scale = 2
		damage_type = 1
		instances = 3
		effects = []
		hit_mod = -0.45
		crit_mod = 0.4
		cooldown = 3
		
class Frostbite:
	extends Skill
	func _init(connection):
		skill_owner = connection
		skill_name = "Frostbite"
		value = 0.80
		attack_scale = 2
		damage_type = 2
		instances = 1
		effects = [["Freeze", 0.05, 2, 0]]
		cooldown = 3

class SimpleStrike:
	extends Skill
	func _init(connection):
		skill_owner = connection
		skill_name = "Simple Strike"
		value = 0.60
		attack_scale = 2
		damage_type = 0
		instances = 1
		effects = []
		cooldown = 2
		
class HeavyHit:
	extends Skill
	func _init(connection):
		skill_owner = connection
		skill_name = "Dual Strike"
		value = 1.10
		attack_scale = 2
		damage_type = 0
		instances = 1
		effects = []
		cooldown = 4
		
		
class MagicStrike:
	extends Skill
	func _init(connection):
		skill_owner = connection
		skill_name = "Dual Strike"
		value = 1.10
		attack_scale = 2
		damage_type = 0
		instances = 1
		effects = []
		cooldown = 4
	func call_skill(stats):
			return (0.5 * stats[2]) + (0.3 * stats[5])
			
class RedRail:
	extends Skill
	func _init(connection):
		skill_owner = connection
		skill_name = "Red Rail"
		value = 3.00
		attack_scale = 2
		damage_type = 0
		instances = 1
		effects = []
		cooldown = 4
	func call_skill(stats):
		pass
class Overclock:
	extends Skill
	func _init(connection):
		skill_owner = connection
		skill_name = "Overclock"
		value = 0.00
		attack_scale = 2
		damage_type = 0
		instances = 1
		effects = [["AttackUp", 999.00, 3, 0]]
		target_type = 5
		cooldown = 4
	func call_skill(stats):
		trigger_cooldown()
		effects[0][3] = (attack_scale * 0.3)
		return [false, false, effects]
class Blaze:
	extends Skill
	func _init(connection):
		skill_owner = connection
		skill_name = "Blaze"
		value = 0.40
		attack_scale = 2
		damage_type = 1
		instances = 1
		effects = [["OnFire", 1.00, 2, get_scaling_value("attack", 0.3)]]
		cooldown = 2
class Fury:
	extends Skill
	func _init(connection):
		skill_owner = connection
		skill_name = "Fury"
		value = 0.00
		attack_scale = 2
		damage_type = 0
		instances = 1
		effects = [["AttackUp", 999.00, 2, effect_scale_stat]]
		target_type = 7
		cooldown = 5
	func call_skill(stats):
		trigger_cooldown()
		effects[0][3] = (stats[attack_scale] * 0.25)
		return [false, false, effects]
		pass
		
class Heal:
	extends Skill
	func _init(connection):
		skill_owner = connection
		skill_name = "Heal"
		value = 0.10
		attack_scale = 1
		damage_type = -1
		instances = 1
		effects = []
		cooldown = 3
