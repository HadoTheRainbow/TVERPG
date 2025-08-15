extends Button

class_name CharacterEntity

@onready var effect_name_dict = EffectDict.new()

signal change_max
signal target(identifier: int)
signal die(value)
signal animate_num(value)
signal new_damage_num(value)

const HIT = preload("res://Assets/Sfx/Hit.mp3")
const DAMAGE_COLORS_INNER = [
	Color("ffffff"), 
	Color("ffaa33"), 
	Color("2040ff"), 
	Color("8abb73"), 
	Color("100010"), 
	Color("99ccff"), 
	Color("001422"), 
	Color("ffffff"), 
	Color("cc0000"), 
	Color("ffffff"),
	]
const DAMAGE_COLORS_OUTER = [
	Color("000000"), 
	Color("703e11"), 
	Color("051088"), 
	Color("3a7732"), 
	Color("40106b"), 
	Color("ffffff"), 
	Color("208799"), 
	Color("eeeecc"), 
	Color("000000"), 
	Color("ffffff"),
	]
const DAMAGE_TYPES = ["Physical", "Fire", "Water", "Poison", "Void", "Ice", "Sonic", "Radiant", "Soul", "Chromatic",]
#phys, fire, water, poison, void, ice, sonic, radiant, 
var rng = RandomNumberGenerator.new()

#var load = preload("res://Battle/battle_window.gd")
var dam_nums_id
var connect1 = load("res://Battle/battle_window.gd")
var display
var dam_display
var display2
var id: int
var entity_id: int
var stats = true
var max_enemies: int
var max_heroes: int
var designation: bool
var h_order = 0
var e_order = 0
var level = 1
var death_anim_play = 0
var flash
var texture

const UPPER_BOUND = 500
const LOWER_BOUND = 500
const LEFT_BOUND = 800
const RIGHT_BOUND = 1000

func determine_stats(a):
	var b = EntitiesDict.new()
	stats = b.character_list[a]
	stats.connector = self
	stats.id = id
	stats.is_hero = designation
	stats.lvl = level
	stats.connector = self
	stats.reload()

# Called when the node enters the scene tree for the first time.
func _ready():
	flash = get_node("Sprite2D/Flash")
	flash.play("RESET")
	
	display = get_node("Sprite2D")
	dam_display = get_node("Path2D/PathFollow2D/RichTextLabel")
	get_parent().do_damage.connect(Callable(self, "_damage"))
	get_parent().do_heal.connect(Callable(self, "_heal"))
	get_parent().change_max.connect(Callable(self, "_update_max"))
	determine_stats(entity_id)
	display2 = CharacterList.new(entity_id)
	texture = load("res://Assets/"+display2.display+".png")
	if designation:
		max_heroes = get_parent().max_heroes
		h_order = max_heroes
		print("Hero spawned! It's ID is " + str(stats.id))
		print("Number of heroes: "+ str(max_heroes))
		print(stats.char_name + "'s Hp is at "+ str(stats.hp))
		display.flip_h = false
	else:
		max_enemies = get_parent().max_enemies
		e_order = max_enemies
		print("enemy spawned! It's ID is " + str(stats.id))
		print("Number of enemies: "+ str(max_enemies))
		print(stats.char_name + "'s Hp is at "+ str(stats.hp))
		display.flip_h = true
		
	
	
	#if id == 2:
		#display.texture = load("res://Assets/hado battle 1.png")
	#get_parent().connect("target", Callable(get_parent(), "_enemy_targeted"))
	#print(connect.max_enemies)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if stats.is_hero:
		position.y = ((h_order * 30 / max_heroes * 10) -475)
		position.x = ((h_order * -30 / max_heroes * 15) + 150)
	else:
		position.y = ((e_order * 30 / max_enemies * 10) -475)
		position.x = ((e_order * 30 / max_enemies * 15) + 600)
	#max_enemies = get_parent().max_enemies
	if stats.is_alive():
		display.texture = texture
	else:
		if !stats.is_hero:
			death_anim_play += delta * 5
			if death_anim_play > 10:
				die.emit(e_order, designation, id)
				self.queue_free()
	
func receive_attack(data: Array):
	if data.size() > 0:
		if typeof(data[0]) == TYPE_INT:
			if data[1] == -1:
				_heal(data[0])
			else:
				_damage(data[0], data[1])
			var x = 2
			for i in (data.size() - 2):
				obtain_effect(data[x][0], data[x][1], data[0][1])
				print("effect given")
				x += 1
				
func obtain_effect(effect_name, duration, value):
	for i in stats.status_effects:
		if i.effect_name == effect_name:
			i.effect_instances.append([value, duration])
			print("effects added")
			return
	stats.status_effects.append(effect_name_dict.effect_list[effect_name])
	print("new effects added")
	
	
	
	pass


func _damage(value, dam_type):
	if id == id:
		var damage_type = dam_type
		if damage_type == 9:
			damage_type = rng.randi_range(0, 8)
			print(damage_type)
		var damage = stats.take_damage(value, damage_type)
		if typeof(damage) == TYPE_INT:
			summon_damage_num(damage, false, damage_type)
		#print(str(stats.attack))
			print("HP of enemy " + str(id) +" reduced to "+ str(stats.hp))
			flash.stop()
			flash.play("RESET")
			flash.play("flash")
			$AudioStreamPlayer2D.stream = HIT
			$AudioStreamPlayer2D.play()
			new_damage_num.emit(dam_nums_id)
			if !stats.is_alive():
				print("Enemy defeated!!")
				if stats.is_hero:
					#die.emit(h_order)
					display.texture = load("res://Assets/dead.png")
				else:
					flash.stop()
					flash.play("RESET")
					flash.play("die")
		else:
			pass
func _heal(value):
	if id == id:
		var healt = stats.heal(value)
		summon_damage_num(healt, true, 0)
		print("HP of enemy " + str(id) +" increased to "+ str(stats.hp))
		flash.stop()
		flash.play("RESET")
		flash.play("flash_alt")
		new_damage_num.emit(dam_nums_id)
		if !stats.is_alive():
			print("Enemy unhealed!!")
			if stats.is_hero:
				#die.emit(h_order)
				display.texture = load("res://Assets/dead.png")
			else:
				flash.stop()
				flash.play("RESET")
				flash.play("die")

func get_stat(value):
	if typeof(stats) != TYPE_BOOL:
		return stats.get_stat(value)


func _update_max(value, order_value, side_hero):
	if side_hero:
		max_heroes = value
		if h_order > order_value:
			h_order -= 1
	else:
		max_enemies = value
		if e_order > order_value:
			e_order -= 1

func _on_pressed():
	if get_parent().target_ask:
		target.emit(id)
	else:
		print("select a skill first!")
		
func summon_damage_num(dam, is_heal, type):
	var num = load("res://Battle/damage_num_path.tscn").instantiate()
	num.get_node("PathFollow2D/RichTextLabel").text = ("[center]" + str(dam) + "[/center]")
	num.get_node("PathFollow2D").is_child = true
	num.get_node("PathFollow2D").link = self
	if is_heal:
		num.get_node("PathFollow2D/RichTextLabel").set("theme_override_colors/default_color", Color(0.0, 1.0, 0.0, 1.0))
	else:
		if dam == 0:
			num.get_node("PathFollow2D/RichTextLabel").text = ("[center]IMMUNE[/center]")
		num.get_node("PathFollow2D/RichTextLabel").set("theme_override_colors/default_color",DAMAGE_COLORS_INNER[type])
		num.get_node("PathFollow2D/RichTextLabel").set("theme_override_colors/font_outline_color",DAMAGE_COLORS_OUTER[type])
		#print(DAMAGE_TYPES[type])
	add_child(num)
