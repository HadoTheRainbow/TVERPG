extends Button
class_name CharacterEntity

@onready var effect_name_dict: EffectDict = EffectDict.new()

signal change_max
signal target(identifier: int)
signal die(value)
signal animate_num(value)
signal new_damage_num(value)

const HIT: AudioStream = preload("res://Assets/Sfx/Hit.mp3")

# Damage Colors
const DAMAGE_COLORS_INNER: Array[Color] = [
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

const DAMAGE_COLORS_OUTER: Array[Color] = [
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

const DAMAGE_TYPES: Array[String] = [
    "Physical", "Fire", "Water", "Poison", "Void", 
    "Ice", "Sonic", "Radiant", "Soul", "Chromatic"
]

# Position Constants
const HERO_POS_Y_OFFSET = -475
const HERO_POS_X_OFFSET = 150
const ENEMY_POS_Y_OFFSET = -475
const ENEMY_POS_X_OFFSET = 600
const HERO_POS_Y_MULTIPLIER = 30
const HERO_POS_X_MULTIPLIER = -30
const ENEMY_POS_Y_MULTIPLIER = 30
const ENEMY_POS_X_MULTIPLIER = 30
const HERO_POS_Y_SCALE = 10
const HERO_POS_X_SCALE = 15
const ENEMY_POS_Y_SCALE = 10
const ENEMY_POS_X_SCALE = 15

# Damage Type Constants
const DAMAGE_TYPE_CHROMATIC = 9
const DAMAGE_TYPE_RANDOM_MIN = 0
const DAMAGE_TYPE_RANDOM_MAX = 8

# Animation / Timing Constants
const DEATH_ANIM_SPEED = 5.0
const DEATH_ANIM_THRESHOLD = 10.0

# Other Constants
const HEAL_COLOR = Color(0.0, 1.0, 0.0, 1.0)
const IMMUNE_TEXT = "[center]IMMUNE[/center]"

var rng = RandomNumberGenerator.new()

var dam_nums_id: int
var connect1 = load("res://Battle/battle_window.gd")
var display: Sprite2D
var dam_display: RichTextLabel
var display2: CharacterList
var id: int
var entity_id: int
var stats = true
var max_enemies: int
var max_heroes: int
var designation: bool
var h_order = 0
var e_order = 0
var level = 1
var death_anim_play = 0.0
var flash: AnimationPlayer
var texture: Texture2D

func determine_stats(index: int) -> void:
    var newEntityDict: EntitiesDict = EntitiesDict.new()

    stats = newEntityDict.character_list[index]
    stats.connector = self
    stats.id = id
    stats.is_hero = designation
    stats.lvl = level
    stats.connector = self
    stats.reload()

func _ready() -> void:
    flash = get_node("Sprite2D/Flash")
    flash.play("RESET")

    display = get_node("Sprite2D")
    dam_display = get_node("Path2D/PathFollow2D/RichTextLabel")

    get_parent().do_damage.connect(Callable(self, "_damage"))
    get_parent().do_heal.connect(Callable(self, "_heal"))
    get_parent().change_max.connect(Callable(self, "_update_max"))
    determine_stats(entity_id)

    display2 = CharacterList.new(entity_id)
    texture = load("res://Assets/" + display2.display + ".png")

    if designation:
        max_heroes = get_parent().max_heroes
        h_order = max_heroes

        print("Hero spawned! It's ID is " + str(stats.id))
        print("Number of heroes: " + str(max_heroes))
        print(stats.char_name + "'s Hp is at " + str(stats.hp))
        display.flip_h = false
    else:
        max_enemies = get_parent().max_enemies
        e_order = max_enemies

        print("Enemy spawned! It's ID is " + str(stats.id))
        print("Number of enemies: " + str(max_enemies))
        print(stats.char_name + "'s Hp is at " + str(stats.hp))
        display.flip_h = true

func _process(delta: float) -> void:
    if stats.is_hero:
        position.y = ((h_order * HERO_POS_Y_MULTIPLIER / max_heroes * HERO_POS_Y_SCALE) + HERO_POS_Y_OFFSET)
        position.x = ((h_order * HERO_POS_X_MULTIPLIER / max_heroes * HERO_POS_X_SCALE) + HERO_POS_X_OFFSET)
    else:
        position.y = ((e_order * ENEMY_POS_Y_MULTIPLIER / max_enemies * ENEMY_POS_Y_SCALE) + ENEMY_POS_Y_OFFSET)
        position.x = ((e_order * ENEMY_POS_X_MULTIPLIER / max_enemies * ENEMY_POS_X_SCALE) + ENEMY_POS_X_OFFSET)

    if stats.is_alive():
        display.texture = texture
    else:
        if stats.is_hero:
            return

        death_anim_play += delta * DEATH_ANIM_SPEED
        if death_anim_play > DEATH_ANIM_THRESHOLD:
            die.emit(e_order, designation, id)
            self.queue_free()

func receive_attack(data: Array) -> void:
    if data.is_empty():
        return
    if typeof(data[0]) == TYPE_INT:
        if data[1] == -1:
            _heal(data[0])
        else:
            _damage(data[0], data[1])

        var x: int = 2
        for i in (data.size() - 2):
            obtain_effect(data[x][0], data[x][1], data[0][1])
            print("effect given")
            x += 1

func obtain_effect(effect_name: String, duration: int, value: int) -> void:
    for i in stats.status_effects:
        if i.effect_name == effect_name:
            i.effect_instances.append([value, duration])
            print("effects added")
            return

    stats.status_effects.append(effect_name_dict.effect_list[effect_name])
    print("new effects added")

func _damage(value: int, dam_type: int) -> void:
    if id != id:
        return

    var damage_type: int = dam_type

    if damage_type == DAMAGE_TYPE_CHROMATIC:
        damage_type = rng.randi_range(DAMAGE_TYPE_RANDOM_MIN, DAMAGE_TYPE_RANDOM_MAX)
        print(damage_type)

    var damage: Variant = stats.take_damage(value, damage_type)

    if typeof(damage) == TYPE_INT:
        summon_damage_num(damage, false, damage_type)
        print("HP of enemy " + str(id) + " reduced to " + str(stats.hp))

        flash.stop()
        flash.play("RESET")
        flash.play("flash")

        $AudioStreamPlayer2D.stream = HIT
        $AudioStreamPlayer2D.play()

        new_damage_num.emit(dam_nums_id)
        if !stats.is_alive():
            print("Enemy defeated!!")
            if stats.is_hero:
                display.texture = load("res://Assets/dead.png")
            else:
                flash.stop()
                flash.play("RESET")
                flash.play("die")

func _heal(value: int) -> void:
    if id != id:
        return

    var healed: int = stats.heal(value)
    summon_damage_num(healed, true, 0)
    print("HP of enemy " + str(id) + " increased to " + str(stats.hp))

    flash.stop()
    flash.play("RESET")
    flash.play("flash_alt")

    new_damage_num.emit(dam_nums_id)

    if !stats.is_alive():
        print("Enemy unhealed!!")
        if stats.is_hero:
            display.texture = load("res://Assets/dead.png")
        else:
            flash.stop()
            flash.play("RESET")
            flash.play("die")

func get_stat(value: String) -> Variant:
    if typeof(stats) != TYPE_BOOL:
        return stats.get_stat(value)
    return null

func _update_max(value: int, order_value: int, side_hero: bool) -> void:
    if side_hero:
        max_heroes = value
        if h_order > order_value:
            h_order -= 1
    else:
        max_enemies = value
        if e_order > order_value:
            e_order -= 1

func _on_pressed() -> void:
    if get_parent().target_ask:
        target.emit(id)
    else:
        print("select a skill first!")

func summon_damage_num(dam: int, is_heal: bool, type: int) -> void:
    var num: Node2D = load("res://Battle/damage_logic/damage_num_path.tscn").instantiate()
    var label: RichTextLabel = num.get_node("PathFollow2D/RichTextLabel")

    label.text = "[center]" + str(dam) + "[/center]"
    num.get_node("PathFollow2D").is_child = true
    num.get_node("PathFollow2D").link = self

    if is_heal:
        label.set("theme_override_colors/default_color", HEAL_COLOR)
    else:
        if dam == 0:
            label.text = IMMUNE_TEXT
        label.set("theme_override_colors/default_color", DAMAGE_COLORS_INNER[type])
        label.set("theme_override_colors/font_outline_color", DAMAGE_COLORS_OUTER[type])

    add_child(num)
