extends Node2D
@onready var dungeon_map = $".."
var invisrooms=0
var Idolroom=false
@onready var Roomtexture: TextureRect = $TextureRect
@onready var RoomType = { #this serves no purpose it didnt work
		"Encounter":load("res://Assets/MapAssets/Encounter50x50.png"),
		"FormidableEncounter":load("res://Assets/MapAssets/FormidableEncounter50x50.png"),
		"OminousEncounter":load("res://Assets/MapAssets/OminousEncounter50x50.png"),
		"BossEncounter":load("res://Assets/MapAssets/BossEncounter50x50.png"),
		"Shop":load("res://Assets/MapAssets/Shop50x50.png"),
		"Treasure":load("res://Assets/MapAssets/Treasure50x50.png"),
		"GrandTreasure":load("res://Assets/MapAssets/GrandTreasure50x50.png"),
		"HealingFountain":load("res://Assets/MapAssets/HealingFountain50x50.png"),
		"IdolRoom":load("res://Assets/MapAssets/IdolRoom50x50.png"),
		"CheckpointRoom":load("res://Assets/MapAssets/CheckpointRoom50x50.png"),
		"Invisible":load("res://Assets/MapAssets/Invisible50x50.png"),
		"NoRoom":1
	}


func GenerateRoom(DungeonType,x) -> String:
	
	match DungeonType:
		0:
			if x==1:return "Encounter"
			elif x==3:return "HealingFountain"
			elif x==dungeon_map.Lenght-2:return "HealingFountain"
			elif x==dungeon_map.Lenght-1:return "FormidableEncounter"
			else:
				var i = randi_range(1,7)
				match i:
					7:
						print("healing fountain")
						return "HealingFountain"
					var n when n>4 and n<7:
						print("booty")
						return "Treasure"
					_:
						print("encounter")
						return "Encounter"
		1:
			if x ==0: return "Encounter"
			if x==dungeon_map.Lenght-2: return "HealingFountain"
			if x==dungeon_map.Lenght-1: return "BossEncounter"
			var i = randi_range(1,18)
			match i:
				var n when n<=4:return "Encounter"
				var n when n>=5 and n<=6:return "FormidableEncounter"
				var n when n>=7 and n<=9:return "OminousEncounter"
				var n when n>=10 and n<=11:
					if invisrooms>3:
						return GenerateRoom(DungeonType,x)
					else:
						return "Invisible"
						invisrooms+=1
				var n when n>=12 and n<=13:return "Shop"
				var n when n>=14 and n<=15:return "Treasure"
				var n when n>=16 and n<=17:return "HealingFountain"
				var n when n==18:
					if Idolroom==false:
						return "idol"
						Idolroom=true
					else:
						return GenerateRoom(DungeonType,x)
						
		_: return ""
	return ""
func InstantiateTexture(y,x,RoomType) -> void:
	match RoomType:
		"Encounter":dungeon_map.RoomNodeDungeonLayout[y][x].Roomtexture.texture = load("res://Assets/regular_encounter.png")
		"FormidableEncounter":dungeon_map.RoomNodeDungeonLayout[y][x].Roomtexture.texture = load("res://Assets/formidable_encounter.png")
		"OminousEncounter":dungeon_map.RoomNodeDungeonLayout[y][x].Roomtexture.texture = load("res://Assets/ominous_encounter.png")
		"BossEncounter":dungeon_map.RoomNodeDungeonLayout[y][x].Roomtexture.texture = load("res://Assets/boss.png")
		"Shop":dungeon_map.RoomNodeDungeonLayout[y][x].Roomtexture.texture = load("res://Assets/shop.png")
		"Treasure":dungeon_map.RoomNodeDungeonLayout[y][x].Roomtexture.texture = load("res://Assets/treasure.png")
		"GrandTreasure":dungeon_map.RoomNodeDungeonLayout[y][x].Roomtexture.texture = load("res://Assets/treasure.png")
		"HealingFountain":dungeon_map.RoomNodeDungeonLayout[y][x].Roomtexture.texture = load("res://Assets/healing_room.png")
		"Idol":dungeon_map.RoomNodeDungeonLayout[y][x].Roomtexture.texture = load("res://Assets/idol.png")
		"Checkpoint":dungeon_map.RoomNodeDungeonLayout[y][x].Roomtexture.texture = load("res://Assets/checkpoint.png")
		"Invisible":dungeon_map.RoomNodeDungeonLayout[y][x].Roomtexture.texture = load("res://Assets/")
func Position(x,y,Lanes) ->void:
	var Pos = y
	var Lane = x
	position = Vector2(x*300 -64,y*(1080/(Lanes+1))-64)
	
