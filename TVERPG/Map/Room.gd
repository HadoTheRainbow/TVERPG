extends Node2D
@onready var dungeon_map = $".."

@onready var Roomtexture: TextureRect = $TextureRect
@onready var RoomType = {
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


func GenerateRoom(DungeonType,y):
	
		match DungeonType:
			0:
				if y==1:
					return "Encounter"
				elif y==3:
					return "HealingFountain"
				elif y==dungeon_map.Lenght-2:
					return "HealingFountain"
				elif y==dungeon_map.Lenght-1:
					return "FormidableEncounter"
				else:
					var x = randi_range(1,7)
					match x:
						7:
							print("healing fountain")
							return "HealingFountain"
						6:
							print("booty")
							return "Treasure"
						5:
							print("booty")
							return "Treasure"
						_:
							print("encounter")
							return "Encounter"
			1:return "Invisible"
			_: return ""
func InstantiateTexture(y,x,RoomType):
	match RoomType:
		"Encounter":dungeon_map.RoomNodeDungeonLayout[y][x].Roomtexture.texture = load("res://Assets/MapAssets/Encounter50x50.png")
		"FormidableEncounter":dungeon_map.RoomNodeDungeonLayout[y][x].Roomtexture.texture = load("res://Assets/MapAssets/FormidableEncounter50x50.png")
		"OminousEncounter":dungeon_map.RoomNodeDungeonLayout[y][x].Roomtexture.texture = load("res://Assets/MapAssets/OminousEncounter50x50.png")
		"BossEncounter":dungeon_map.RoomNodeDungeonLayout[y][x].Roomtexture.texture = load("res://Assets/MapAssets/BossEncounter50x50.png")
		"Shop":dungeon_map.RoomNodeDungeonLayout[y][x].Roomtexture.texture = load("res://Assets/MapAssets/Shop50x50.png")
		"Treasure":dungeon_map.RoomNodeDungeonLayout[y][x].Roomtexture.texture = load("res://Assets/MapAssets/Treasure50x50.png")
		"GrandTreasure":dungeon_map.RoomNodeDungeonLayout[y][x].Roomtexture.texture = load("res://Assets/MapAssets/GrandTreasure50x50.png")
		"HealingFountain":dungeon_map.RoomNodeDungeonLayout[y][x].Roomtexture.texture = load("res://Assets/MapAssets/HealingFountain50x50.png")
		"Idol":dungeon_map.RoomNodeDungeonLayout[y][x].Roomtexture.texture = load("res://Assets/MapAssets/IdolRoom50x50.png")
		"Checkpoint":dungeon_map.RoomNodeDungeonLayout[y][x].Roomtexture.texture = load("res://Assets/MapAssets/CheckpointRoom50x50.png")
		"Invisible":dungeon_map.RoomNodeDungeonLayout[y][x].Roomtexture.texture = load("res://Assets/MapAssets/Invisible50x50.png")
func Position(x,y,Lanes):
	var Pos = y
	var Lane = x
	position = Vector2(x*300,y*(1080/(Lanes+1)))
	
