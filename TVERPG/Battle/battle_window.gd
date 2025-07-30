extends Control

#class_name Character

signal change_max(new_val)
signal do_damage(target, value)
signal do_heal(target, value)
signal get_stat(target, value)



var enemy_node = preload("res://Battle/character.tscn")
var default_skills_list = import_array_from_file("res://Battle/skill_data.json")
var player_stats = import_array_from_file("res://Battle/stat_block_data.json")
#var default_skills_sections = get_sections(default_skills_list)
#var player_stats_sections = get_sections(player_stats)
var skills = [0, 3, 3, 3]
var heroes = [1, 2, 3]
var enemies = [1, 1, 1]

var entities_list = []
var cooldowns = []
var hero_array_stats = [player_stats[2+heroes[0]],player_stats[2+heroes[1]],player_stats[2+heroes[2]]]
var enemy_array_stats = []
var battle_order = []
var state_of_battle = 1
var skill_special_connect
var skill_1_connect
var skill_2_connect
var skill_3_connect
var max_enemies = 0
var max_enemies2 = 0
var max_entities = 0
var max_heroes = 0
var max_heroes2 = 0
var target_ask = true
var target = 0
var summon = 0
var dam_type = 0

const DAMAGE_TYPES = ["Physical", "Fire", "Water", "Poison", "Void", "Ice", "Sonic", "Radiant", "Soul", "Chromatic",]

#class Skill: 
	#var id: int
	#var name: String
	#var damage_type: int
	#var scaling_stat: String
	#var stat_modifier: float
	#var target_type: String
	#var repeats: int
	#var instances: int
	#var cooldown: int
	#var hit_rate: int
	#var crit_rate: int
	#var additional_effects: Array
	#var stat_value: int
	
	
func chosen_target_enemy() -> String:
	return "a chosen opponent"
func chosen_target_ally() -> String:
	return "a chosen ally"
func random_target_enemy() ->String:
	return "a random opponent"
func random_target_ally() ->String:
	return "a random ally"
func all_target_enemy() ->String:
	return "all opponents"
func all_target_ally() ->String:
	return "all allies"
func calculate_damage(stat, modifier) ->int:
	if stat == "atk":
		return battle_order[0][2] * modifier
	if stat == "hp":
		return battle_order[0][1] * modifier
	return 0
	

	
func initialize_battle():
	battle_order.sort_custom(sort_battle_order)
	for x in heroes.size():
		cooldowns.append_array([0, 0, 0, 0,])
	for x in enemies.size():
		cooldowns.append_array([0, 0, 0, 0,])
	var y = 0
	for x in [skill_special_connect, skill_1_connect, skill_2_connect, skill_3_connect]:
		update_skill_name(x,cooldowns[y])
		y=y+1
	print("ready 2!")
		
func next_round_flag():
	battle_order = hero_array_stats + enemy_array_stats
	battle_order.sort_custom(sort_battle_order)
	state_of_battle = 1
	print("Round start!")
func next_turn_flag():
	if battle_order.size() > 1:
		battle_order.pop_at(0)
	else:
		next_round_flag()
		return
	state_of_battle = state_of_battle+1
	print("Next turn! ")
	
	
func sort_order():
	var temp_arr = []
	var temp_arr2 = []
	for i in max_entities:
		if entities_list[i] != null:
			temp_arr.append([i, get_stats(i, "speed")])
	print(temp_arr)
	temp_arr.sort_custom(sort_battle_order)
	for i in temp_arr:
		temp_arr2.append(i[0])
	return temp_arr2
func sort_battle_order(a, b):
	if a[1] > b[1]:
		return true
	return false

func use_attack_skill(skill_name, skill_damage_type, skill_stat, skill_damage_modifier, skill_target_type, skill_instances, skill_damage_instances, skill_cooldown, skill_hit_rate_modifier, skill_crit_rate_modifier, skill_crit_damage_modifier, skill_extra_info):
	var skill_target = Callable(self, skill_target_type)
	var damage_out = calculate_damage(skill_stat, skill_damage_modifier)
	print(battle_order[0][0] + " uses " + skill_name)
	print("This attack targets " + skill_target.call())
	print("This attack deals " + str(damage_out) + " " + skill_damage_type + " damage a total of " + str(skill_instances) + "  times!" )
	if (skill_extra_info != "none"):
		print("This skill will inflict " + str(skill_extra_info))
	else:
		pass
	print("Now on cooldown for " + str(skill_cooldown) + " rounds!")
	#cooldown[][]
	#next_turn_flag()
	
	
func import_array_from_file(file_path: String) -> Array:
	var file = FileAccess.open(file_path, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	return JSON.parse_string(content)

#func get_sections(arr):
	#var temp_arr = []
	#var y = 0
	#for x in arr:
		#if typeof(x) == TYPE_STRING:
			#if x != "Ignore":
				#temp_arr.append(y)
		#y = y+1
	#return temp_arr

func update_skill_name(skill_to_be_updated, update_skill_cd):
	if update_skill_cd > 0:
		skill_to_be_updated.disabled = true
		skill_to_be_updated.text = default_skills_list[1][0].to_upper() + "  (" + str(update_skill_cd) + ")"
	else:
		skill_to_be_updated.disabled = false
		skill_to_be_updated.text = default_skills_list[1][0].to_upper()
	
	pass

func get_stats(a, b):
	return entities_list[a].get_stat(b)
	#get_children()

# Called when the node enters the scene tree for the first time.
func _ready():
	#var hero_1_stats = 
	print("ready!")
	skill_special_connect = $Options/SkillSpecial
	skill_1_connect = $Options/Skill1
	skill_2_connect = $Options/Skill2
	skill_3_connect = $Options/Skill3
	initialize_battle()
	
	pass
	
func _process(delta):
	#if max_enemies2 != max_enemies:
		#max_enemies = max_enemies2
		#change_max.emit(max_enemies, 1000000)
	pass
	
func _enemy_targeted(id):
	print("targeted zynthclones with id " + str(id))
	target = id
	
func _receive_obituary(value, des, id2):
	#entities_list[id2] = null
	if des:
		max_heroes -= 1
		change_max.emit(max_heroes, value, true)
	else:
		max_enemies -= 1
		change_max.emit(max_enemies, value, false)

# BUTTONS
func _on_skill_normal_pressed():
	#callv("use_attack_skill", default_skills_list[2+default_skills_sections[5]])
	pass
func _on_skill_special_pressed():
	do_damage.emit(target, 20, dam_type)

func _on_skill_1_pressed():
	do_heal.emit(target, 20)
	#callv("use_attack_skill", default_skills_list[skills[1]])
	#print("-----------awaiting next input")
	#update_skill_name(skill_1_connect, default_skills_list[skills[1]][7])

func _on_skill_2_pressed():
	#callv("use_attack_skill", default_skills_list[skill_2])
	battle_order.sort_custom(sort_battle_order)
	print(battle_order)
	print("-----------awaiting next input")
	


func _on_skill_3_pressed():
#	use_attack_skill("Home Run", "physical", 90, 1.00, "chosen_target_enemy", 1, "stun", 2)
	print(sort_order())
	

func switch_active_hero():
	pass

	
	



func _on_debug_switch_char_pressed():
	if summon >= 7:
		summon = 0
	else:
		summon += 1
	print(summon)


func _on_debug_summon_hero_pressed():
	var chara = enemy_node.instantiate()
	chara.id = max_entities
	chara.entity_id = summon
	chara.designation = true
	#Character.new()

	chara.target.connect(Callable(self, "_enemy_targeted"))
	chara.die.connect(Callable(self, "_receive_obituary"))
	max_heroes += 1
	max_heroes2 += 1
	max_entities += 1
	change_max.emit(max_heroes, max_heroes2, true)
	add_child(chara)


func _on_debug_summon_enemy_pressed():
	var chara = enemy_node.instantiate()
	chara.id = max_entities
	chara.entity_id = summon
	chara.designation = false
	#Character.new()

	chara.target.connect(Callable(self, "_enemy_targeted"))
	chara.die.connect(Callable(self, "_receive_obituary"))
	entities_list.append(chara)
	max_enemies += 1
	max_enemies2 += 1
	max_entities += 1
	change_max.emit(max_enemies, max_enemies2, false)
	add_child(chara)


func _on_debug_switch_element_pressed():
	if dam_type >= 10:
		dam_type = 0
	else:
		dam_type += 1
	print(DAMAGE_TYPES[dam_type])
