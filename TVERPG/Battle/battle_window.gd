extends Control

signal change_max(new_val)
signal do_damage(target, value)
signal do_heal(target, value)
signal get_stat(target, value)



var enemy_node = preload("res://Battle/character.tscn")
var button_get = preload("res://Battle/skill_button.tscn")

@onready var options = get_node("Options")

var entities_list = []
var buttons_list = []

var cooldowns = []
var enemy_array_stats = []
var battle_order = []
var battle_order_total = []
var state_of_battle = 0
var max_enemies = 0
var max_enemies2 = 0
var max_entities = 0
var max_heroes = 0
var max_heroes2 = 0
var target_ask = true
var target = 0
var summon = 0
var dam_type = 0
var queue_skill = 0

const DAMAGE_TYPES = ["Physical", "Fire", "Water", "Poison", "Void", "Ice", "Sonic", "Radiant", "Soul", "Chromatic",]

	
func initialize_turn():
	battle_order = sort_order_2(battle_order_total)
	state_of_battle = 0
	for i in buttons_list:
		i.queue_free()
	buttons_list = []
	var x = 0
	for i in entities_list[battle_order[0]].stats.skills:
		summon_skill_button(x, i.skill_name, i.energy_remain)
		x += 1
		
func end_turn():
	for i in entities_list:
		for n in i.stats.skills:
			n.energy_change(1)
	next_round_flag()
	
	
func next_round_flag():
	battle_order_total = sort_order()
	print("New Round!")
	initialize_turn()
	
func next_turn_flag():
	if battle_order.size() > 1:
		battle_order.pop_at(0)
		battle_order_total.pop_at(0)
		print("Next turn! ")
		initialize_turn()
	else:
		end_turn()
		return
	
	
	
	
	
func sort_order():
	var temp_arr = []
	for i in max_entities:
		if entities_list[i] != null:
			temp_arr.append([i, get_stats(i, "speed")])
	print(temp_arr)
	temp_arr.sort_custom(sort_battle_order)
	return temp_arr
	
func sort_order_2(temp_arr):
	var temp_arr2 = []
	for i in temp_arr:
		temp_arr2.append(i[0])
	return temp_arr2
	
func sort_battle_order(a, b):
	if a[1] > b[1]:
		return true
	return false
	
	
#func import_array_from_file(file_path: String) -> Array:
	#var file = FileAccess.open(file_path, FileAccess.READ)
	#var content = file.get_as_text()
	#file.close()
	#return JSON.parse_string(content)

func get_stats(a, b):
	return entities_list[a].get_stat(b)
	#get_children()

# Called when the node enters the scene tree for the first time.
func _ready():
	#var hero_1_stats = 
	print("ready!")
	
	pass
	
func _process(delta):
	#if max_enemies2 != max_enemies:
		#max_enemies = max_enemies2
		#change_max.emit(max_enemies, 1000000)
	pass
	
func _enemy_targeted(id):
	if state_of_battle == 1:
		print("targeted entity with id " + str(id))
		target = id
		for i in entities_list[battle_order[0]].stats.skills[queue_skill].instances:
			entities_list[target].receive_attack(entities_list[battle_order[0]].stats.skills[queue_skill].call_skill(entities_list[battle_order[0]].stats.get_all_attack_stats()))
		state_of_battle = 0
		next_turn_flag()
	else:
		print("choose a skill first!")
func _receive_obituary(value, des, id2):
	#entities_list[id2] = null
	if des:
		max_heroes -= 1
		change_max.emit(max_heroes, value, true)
	else:
		max_enemies -= 1
		change_max.emit(max_enemies, value, false)

# BUTTONS
func _select_skill(tag):
	queue_skill = tag
	target = 0 
	print("select a target to finalize")
	state_of_battle = 1

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
	entities_list.append(chara)
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

func summon_skill_button(tag, butt_name, butt_cooldown):
	var butt = button_get.instantiate()
	butt.id = tag
	butt.cooldown = butt_cooldown
	butt.button_name = butt_name
	buttons_list.append(butt)
	butt.select_skill.connect(Callable(self, "_select_skill"))
	butt.show()
	options.add_child(butt)


func _on_debug_switch_element_pressed():
	if dam_type >= 10:
		dam_type = 0
	else:
		dam_type += 1
	print(DAMAGE_TYPES[dam_type])
	



func _on_start_pressed():
	next_round_flag()
