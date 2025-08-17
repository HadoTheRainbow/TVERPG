extends Node

class_name SkillsDict

var connector

var character_list = {
    "Normal": Skill.Normal.new(0, connector),
    "FlameBlade": Skill.FlameBlade.new(connector),
    "Fury": Skill.FlameBlade.new(connector),
    "MagicStrike": Skill.MagicStrike.new(connector),
    "Blaze": Skill.Blaze.new(connector),
    "Hit": Skill.DefaultHit.new(connector),
    "Special": Skill.DefaultSpecial.new(connector),
    "Heal": Skill.Heal.new(connector),
    "Overclock": Skill.Overclock.new(connector),
    "DualStrike": Skill.DualStrike.new(connector),
    "InfinitePain": Skill.InfinitePain.new(connector),

}
