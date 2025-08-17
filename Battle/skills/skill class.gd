extends CharacterEntity
class_name Skill

# ENUMS
enum DAMAGE_TYPESe {
    PHYSICAL,
    FIRE,
    WATER,
    POISON,
    VOID,
    ICE,
    SONIC,
    RADIANT,
    SOUL,
    CHROMATIC,
    DIVINE,
    REALITY,
    HEALING = -1,
    NULL = -2, # Not a real damage type
}

enum TARGET_TYPES {
    TARGET_SINGLE_ENEMY,
    TARGET_RANDOM_ENEMY,
    TARGET_ALL_ENEMIES,
    TARGET_ALLY,
    TARGET_RANDOM_ALLY,
    TARGET_ALL_ALLIES,
    TARGET_ALL,
    TARGET_SELF,
    CUSTOM_TARGET,
    NULL = -1, # Not a real target type
}

# Default scaling stats (indexes)
const STAT_ATTACK = 2
const STAT_MAGIC  = 5

# Modifiers
const DEFAULT_INSTANCES = 1
const DEFAULT_REPEATS = 0
const DEFAULT_VALUE = 0.0
const DEFAULT_ATTACK_SCALE = STAT_ATTACK
const MIN_RANDOM = 0.0
const MAX_RANDOM = 1.0
const EFFECT_PERMANENT_DURATION = 999.0

# Multipliers
const CRIT_BONUS_LOW = 0.25
const CRIT_BONUS_MED = 0.30
const CRIT_BONUS_HIGH = 0.50

# Class Variables

var skill_name: String
var value = DEFAULT_VALUE
var attack_scale = DEFAULT_ATTACK_SCALE
var damage_type = DAMAGE_TYPESe.NULL
var target_type = TARGET_TYPES.NULL
var instances = DEFAULT_INSTANCES
var repeats = DEFAULT_REPEATS
var effects = []
var export_effects = []
var cooldown = 0
var energy_remain = 0
var effect_scale_stat

var skill_owner

var hit_mod = 0.0
var crit_mod = 0.0
var crit_d_mod = 0.0

# Keys for effect dictionaries
const EFFECT_NAME     = "name"
const EFFECT_CHANCE   = "chance"
const EFFECT_DURATION = "duration"
const EFFECT_POWER    = "power"

func call_skill(stats_skill: Array) -> Array:
    trigger_cooldown()

    if effects.is_empty():
        return [int(value * stats_skill[attack_scale]), damage_type]
    else:
        var arr = [value * stats_skill[attack_scale], damage_type]
        export_effects = []

        for i in effects:
            var temp_var = roll_effect(i, 0)
            if temp_var != null:
                export_effects.append(temp_var)

        if !export_effects.is_empty():
            arr.append(export_effects)

        return arr

func roll_effect(effect: Dictionary, modifier: float):
    var success_threshold = effect[EFFECT_CHANCE] + modifier
    var roll = rng.randf_range(MIN_RANDOM, MAX_RANDOM)

    if success_threshold >= roll:
        return {
            EFFECT_NAME: effect[EFFECT_NAME],
            EFFECT_DURATION: effect[EFFECT_DURATION],
            EFFECT_POWER: effect[EFFECT_POWER]
        }
    else:
        return null

func get_scaling_value(stat: String, modifier: float):
    if typeof(skill_owner) != TYPE_NIL && typeof(skill_owner.get_stat(stat)) == TYPE_INT:
        return skill_owner.get_stat(stat) * modifier
    pass

func energy_change(v: float) -> void:
    energy_remain = max(0, energy_remain - v)

func trigger_cooldown() -> void:
    energy_remain = cooldown + 1

# Skill Definitions

class Normal:
    extends Skill

    func _init(type: int, connection: CharacterEntity) -> void:
        skill_owner = connection
        skill_name = "Normal"
        value = 0.50
        attack_scale = STAT_ATTACK
        damage_type = type
        target_type = TARGET_TYPES.TARGET_SINGLE_ENEMY

class FlameBlade:
    extends Skill

    func _init(connection: CharacterEntity) -> void:
        skill_owner = connection
        skill_name = "Flame Blade"
        value = 0.60
        attack_scale = STAT_ATTACK
        damage_type = DAMAGE_TYPESe.FIRE
        target_type = TARGET_TYPES.TARGET_SINGLE_ENEMY
        cooldown = 2

class VenomousBite:
    extends Skill

    func _init(connection: CharacterEntity) -> void:
        skill_owner = connection
        skill_name = "Venomous Bite"
        value = 0.60
        attack_scale = STAT_ATTACK
        damage_type = DAMAGE_TYPESe.POISON
        target_type = TARGET_TYPES.TARGET_SINGLE_ENEMY
        effects = [
            {EFFECT_NAME: "Poison", EFFECT_CHANCE: 1.0, EFFECT_DURATION: 2, EFFECT_POWER: 0}
        ]
        cooldown = 5

class InfinitePain:
    extends Skill

    func _init(connection: CharacterEntity) -> void:
        skill_owner = connection
        skill_name = "Infinite Pain"
        value = 0.60
        attack_scale = STAT_ATTACK
        damage_type = DAMAGE_TYPESe.FIRE
        target_type = TARGET_TYPES.TARGET_SINGLE_ENEMY
        instances = 40
        cooldown = 2

class DefaultHit:
    extends Skill

    func _init(connection: CharacterEntity) -> void:
        skill_owner = connection
        skill_name = "Hit"
        value = 1.00
        attack_scale = STAT_ATTACK
        damage_type = DAMAGE_TYPESe.PHYSICAL
        target_type = TARGET_TYPES.TARGET_SINGLE_ENEMY
        cooldown = 3

class DefaultSpecial:
    extends Skill

    func _init(connection: CharacterEntity) -> void:
        skill_owner = connection
        skill_name = "Special"
        value = rng.randf_range(0.60, 0.90)
        attack_scale = STAT_ATTACK
        damage_type = DAMAGE_TYPESe.FIRE
        target_type = TARGET_TYPES.TARGET_SINGLE_ENEMY
        instances = 3
        cooldown = 4

class DualStrike:
    extends Skill

    func _init(connection: CharacterEntity) -> void:
        skill_owner = connection
        skill_name = "Dual Strike"
        value = 0.40
        attack_scale = STAT_ATTACK
        damage_type = DAMAGE_TYPESe.PHYSICAL
        target_type = TARGET_TYPES.TARGET_SINGLE_ENEMY
        instances = 2
        cooldown = 7

class BlindingSlash:
    extends Skill

    func _init(connection: CharacterEntity) -> void:
        skill_owner = connection
        skill_name = "Blinding Slash"
        value = 1.00
        attack_scale = STAT_ATTACK
        damage_type = DAMAGE_TYPESe.RADIANT
        target_type = TARGET_TYPES.TARGET_SINGLE_ENEMY
        effects = [
            {EFFECT_NAME: "Stun", EFFECT_CHANCE: 0.50, EFFECT_DURATION: 1, EFFECT_POWER: 0}
        ]
        cooldown = 5

class DeepBreath:
    extends Skill

    func _init(connection: CharacterEntity) -> void:
        skill_owner = connection
        skill_name = "Deep Breath"
        value = 0.00
        attack_scale = 0
        damage_type = DAMAGE_TYPESe.PHYSICAL
        target_type = TARGET_TYPES.TARGET_SINGLE_ENEMY
        effects = [
            {EFFECT_NAME: "EffectRateUp", EFFECT_CHANCE: 1.0, EFFECT_DURATION: 3, EFFECT_POWER: 0.05},
            {EFFECT_NAME: "CritRateUp",   EFFECT_CHANCE: 1.0, EFFECT_DURATION: 3, EFFECT_POWER: 0.20},
            {EFFECT_NAME: "HitRateUp",    EFFECT_CHANCE: 1.0, EFFECT_DURATION: 3, EFFECT_POWER: 0.50}
        ]
        cooldown = 5

class Firecracker:
    extends Skill

    func _init(connection: CharacterEntity) -> void:
        skill_owner = connection
        skill_name = "Firecracker"
        value = 0.40
        attack_scale = STAT_ATTACK
        damage_type = DAMAGE_TYPESe.FIRE
        target_type = TARGET_TYPES.TARGET_SINGLE_ENEMY
        instances = 3
        hit_mod = -0.45
        crit_mod = 0.40
        cooldown = 3

class Frostbite:
    extends Skill

    func _init(connection: CharacterEntity) -> void:
        skill_owner = connection
        skill_name = "Frostbite"
        value = 0.80
        attack_scale = STAT_ATTACK
        damage_type = DAMAGE_TYPESe.WATER
        target_type = TARGET_TYPES.TARGET_SINGLE_ENEMY
        effects = [
            {EFFECT_NAME: "Freeze", EFFECT_CHANCE: 0.05, EFFECT_DURATION: 2, EFFECT_POWER: 0}
        ]
        cooldown = 3

class SimpleStrike:
    extends Skill

    func _init(connection: CharacterEntity) -> void:
        skill_owner = connection
        skill_name = "Simple Strike"
        value = 0.60
        attack_scale = STAT_ATTACK
        damage_type = DAMAGE_TYPESe.PHYSICAL
        target_type = TARGET_TYPES.TARGET_SINGLE_ENEMY
        cooldown = 2

class HeavyHit:
    extends Skill

    func _init(connection: CharacterEntity) -> void:
        skill_owner = connection
        skill_name = "Heavy Hit"
        value = 1.10
        attack_scale = STAT_ATTACK
        damage_type = DAMAGE_TYPESe.PHYSICAL
        target_type = TARGET_TYPES.TARGET_SINGLE_ENEMY
        cooldown = 4

class MagicStrike:
    extends Skill

    func _init(connection: CharacterEntity) -> void:
        skill_owner = connection
        skill_name = "Magic Strike"
        value = 1.10
        attack_scale = STAT_ATTACK
        damage_type = DAMAGE_TYPESe.PHYSICAL
        target_type = TARGET_TYPES.TARGET_SINGLE_ENEMY
        cooldown = 4

    func call_skill(stats: Array) -> Array:
        return (0.5 * stats[STAT_ATTACK]) + (0.3 * stats[STAT_MAGIC])

class RedRail:
    extends Skill

    func _init(connection: CharacterEntity) -> void:
        skill_owner = connection
        skill_name = "Red Rail"
        value = 3.00
        attack_scale = STAT_ATTACK
        damage_type = DAMAGE_TYPESe.PHYSICAL
        target_type = TARGET_TYPES.TARGET_SINGLE_ENEMY
        cooldown = 4

class Overclock:
    extends Skill

    func _init(connection: CharacterEntity) -> void:
        skill_owner = connection
        skill_name = "Overclock"
        value = 0.00
        attack_scale = STAT_ATTACK
        damage_type = DAMAGE_TYPESe.PHYSICAL
        target_type = TARGET_TYPES.TARGET_ALL_ALLIES
        effects = [
            {EFFECT_NAME: "AttackUP", EFFECT_CHANCE: 0.3, EFFECT_DURATION: EFFECT_PERMANENT_DURATION, EFFECT_POWER: 0}
        ]
        cooldown = 4

    func call_skill(stats: Array) -> Array:
        trigger_cooldown()
        effects[0][EFFECT_POWER] = (attack_scale * CRIT_BONUS_MED)
        return [false, false, effects]

class Blaze:
    extends Skill

    func _init(connection: CharacterEntity) -> void:
        skill_owner = connection
        skill_name = "Blaze"
        value = 0.40
        attack_scale = STAT_ATTACK
        damage_type = DAMAGE_TYPESe.FIRE
        target_type = TARGET_TYPES.TARGET_SINGLE_ENEMY
        effects = [
            {EFFECT_NAME: "OnFire", EFFECT_CHANCE: 1.0, EFFECT_DURATION: 2, EFFECT_POWER: get_scaling_value("attack", CRIT_BONUS_MED)}
        ]
        cooldown = 2

class Fury:
    extends Skill

    func _init(connection: CharacterEntity) -> void:
        skill_owner = connection
        skill_name = "Fury"
        value = 0.00
        attack_scale = STAT_ATTACK
        damage_type = DAMAGE_TYPESe.PHYSICAL
        target_type = TARGET_TYPES.TARGET_SELF
        effects = [
            {EFFECT_NAME: "AttackUp", EFFECT_CHANCE: 1.0, EFFECT_DURATION: 2, EFFECT_POWER: effect_scale_stat}
        ]
        cooldown = 5

    func call_skill(stats: Array) -> Array:
        trigger_cooldown()
        effects[0][EFFECT_POWER] = (stats[attack_scale] * CRIT_BONUS_LOW)
        return [false, false, effects]

class Heal:
    extends Skill

    func _init(connection: CharacterEntity) -> void:
        skill_owner = connection
        skill_name = "Heal"
        value = 0.10
        attack_scale = 1
        damage_type = DAMAGE_TYPESe.HEALING
        target_type = TARGET_TYPES.TARGET_ALLY
        cooldown = 3
