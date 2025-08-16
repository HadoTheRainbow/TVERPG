extends Node2D

class_name DungeonGeneration
@onready var room: Node2D = $Room
@onready var Room:PackedScene = preload("res://Map/Room.tscn")


enum DungeonTypes {Beginning, Basic, Gimmick,Lenient}
@export var ChosenType: DungeonTypes
@export var Lenght : int
@export var Lanes : int
@onready var Crossroad :PackedScene = preload("res://Map/Crossroad.tscn")
@onready var Swap :PackedScene = preload("res://Map/Swap.tscn")
@onready var Corridor :PackedScene = preload("res://Map/Corridor.tscn")
@onready var Converge :PackedScene = preload("res://Map/Converge.tscn")
var DungeonLayout = []
var PathDungeonLayout = []
var NodeDungeonLayout = []
var RoomDungeonLayout = []
var RoomNodeDungeonLayout = []
var roll
var CrossroadRoll
var SwapRoll
@onready var DungeonRandomize = $GenerateDungeon
@onready var camera_2d = $Camera2D
@onready var sprite_2d = $BeginningRoom/Sprite2D

func _ready():
	
	sprite_2d.position = Vector2(0,((Lanes/2))*(1080/(Lanes+1)))
	#sprite_2d.apply_scale(Vector2(1.365/Lanes,1.365/Lanes))
	for x in Lenght:
		DungeonLayout.append([])
		PathDungeonLayout.append([])
		NodeDungeonLayout.append([])
		RoomDungeonLayout.append([])
		RoomNodeDungeonLayout.append([])
		for y in Lanes:
			DungeonLayout[x].append("VoidRoom") 
			PathDungeonLayout[x].append(" ") 
			NodeDungeonLayout[x].append(" ") 
			RoomDungeonLayout[x].append("NoRoom") 
			RoomNodeDungeonLayout[x].append("NoRoom") 
	
	
	DungeonLayout[0][Lanes/2]= "BeginningRoom" # if you want one path then comment out the 2 lines below this
	#DungeonLayout[0][Lanes/2+2]= "BeginningRoom"
	#DungeonLayout[0][Lanes/2]= "BeginningRoom"

func _on_generate_dungeon_pressed():
	for y in Lenght:
		for x in Lanes:
			#print(str(y) + " " + str(x))
			if ChosenType == DungeonTypes.Beginning and x==Lanes/2:
				DungeonLayout[y][x] = DungeonRandomize.GenerateBeginner(y,x)
			elif ChosenType == DungeonTypes.Basic:
				match DungeonLayout[y][x]:
					"BeginningRoom":
						PathDungeonLayout[0][Lanes/2]="URD"
						DungeonLayout[y+1][x]="ConstructionRoom"
						DungeonLayout[y+1][x+1]="ConstructionRoom"
						DungeonLayout[y+1][x-1]="ConstructionRoom"
					"ConstructionRoom":DungeonLayout[y][x] = DungeonRandomize.GenerateBasic(y,x)
			elif ChosenType ==DungeonTypes.Gimmick:
				pass
			elif ChosenType== DungeonTypes.Lenient:
				pass
			#for z in Lenght:
				#print(DungeonLayout[z])
			#print("")
	#for x in Lenght:
		#print(DungeonLayout[x])
	for y in Lenght:
		for x in Lanes:
			match DungeonLayout[y][x]:
				"Corridor": 
					NodeDungeonLayout[y][x] = Corridor.instantiate()
					add_child(NodeDungeonLayout[y][x])
					NodeDungeonLayout[y][x].Position(y,x,Lanes)
				"Crossroad": 
					NodeDungeonLayout[y][x] = Crossroad.instantiate()
					add_child(NodeDungeonLayout[y][x])
					NodeDungeonLayout[y][x].Position(y,x,Lanes)
				"Swap": 
					NodeDungeonLayout[y][x] = Swap.instantiate()
					add_child(NodeDungeonLayout[y][x])
					NodeDungeonLayout[y][x].Position(y,x,Lanes)
				"Converge": 
					NodeDungeonLayout[y][x] = Converge.instantiate()
					add_child(NodeDungeonLayout[y][x])
					NodeDungeonLayout[y][x].Position(y,x,Lanes)
	queue_redraw()
	for y in Lenght:
		for x in Lanes:
			if DungeonLayout[y][x]!="VoidRoom":
				RoomDungeonLayout[y][x] = room.GenerateRoom(ChosenType,y)
				match RoomDungeonLayout[y][x]:
					"Encounter":
						
						RoomNodeDungeonLayout[y][x] = Room.instantiate()
						add_child(RoomNodeDungeonLayout[y][x])
						RoomNodeDungeonLayout[y][x].InstantiateTexture(y,x,"Encounter")
						RoomNodeDungeonLayout[y][x].Position(y,x,Lanes)
					"FormidableEncounter":
						RoomNodeDungeonLayout[y][x] = Room.instantiate()
						add_child(RoomNodeDungeonLayout[y][x])
						RoomNodeDungeonLayout[y][x].InstantiateTexture(y,x,"FormidableEncounter")
						RoomNodeDungeonLayout[y][x].Position(y,x,Lanes)
					"OminousEncounter":
						RoomNodeDungeonLayout[y][x] = Room.instantiate()
						add_child(RoomNodeDungeonLayout[y][x])
						RoomNodeDungeonLayout[y][x].InstantiateTexture(y,x,"OminousEncounter")
						RoomNodeDungeonLayout[y][x].Position(y,x,Lanes)
					"BossEncounter":
						RoomNodeDungeonLayout[y][x] = Room.instantiate()
						add_child(RoomNodeDungeonLayout[y][x])
						RoomNodeDungeonLayout[y][x].InstantiateTexture(y,x,"BossEncounter")
						RoomNodeDungeonLayout[y][x].Position(y,x,Lanes)
					"Shop":
						RoomNodeDungeonLayout[y][x] = Room.instantiate()
						add_child(RoomNodeDungeonLayout[y][x])
						RoomNodeDungeonLayout[y][x].InstantiateTexture(y,x,"Shop")
						RoomNodeDungeonLayout[y][x].Position(y,x,Lanes)
					"Treasure":
						RoomNodeDungeonLayout[y][x] = Room.instantiate()
						add_child(RoomNodeDungeonLayout[y][x])
						RoomNodeDungeonLayout[y][x].InstantiateTexture(y,x,"Treasure")
						RoomNodeDungeonLayout[y][x].Position(y,x,Lanes)
					"GrandTreasure":
						RoomNodeDungeonLayout[y][x] = Room.instantiate()
						add_child(RoomNodeDungeonLayout[y][x])
						RoomNodeDungeonLayout[y][x].InstantiateTexture(y,x,"GrandTreasure")
						RoomNodeDungeonLayout[y][x].Position(y,x,Lanes)
					"HealingFountain":
						RoomNodeDungeonLayout[y][x] = Room.instantiate()
						add_child(RoomNodeDungeonLayout[y][x])
						RoomNodeDungeonLayout[y][x].InstantiateTexture(y,x,"HealingFountain")
						RoomNodeDungeonLayout[y][x].Position(y,x,Lanes)
					"Idol":
						RoomNodeDungeonLayout[y][x] = Room.instantiate()
						add_child(RoomNodeDungeonLayout[y][x])
						RoomNodeDungeonLayout[y][x].InstantiateTexture(y,x,"Idol")
						RoomNodeDungeonLayout[y][x].Position(y,x,Lanes)
					"Checkpoint":
						RoomNodeDungeonLayout[y][x] = Room.instantiate()
						add_child(RoomNodeDungeonLayout[y][x])
						RoomNodeDungeonLayout[y][x].InstantiateTexture(y,x,"Checkpoint")
						RoomNodeDungeonLayout[y][x].Position(y,x,Lanes)
					"Invisible":
						RoomNodeDungeonLayout[y][x] = Room.instantiate()
						add_child(RoomNodeDungeonLayout[y][x])
						RoomNodeDungeonLayout[y][x].InstantiateTexture(y,x,"Invisible")
						RoomNodeDungeonLayout[y][x].Position(y,x,Lanes)
					
	for x in Lenght:
		print(DungeonLayout[x])







func _draw():
	for y in Lenght:
		for x in Lanes:
			if PathDungeonLayout[y][x].contains("D"):
				draw_line(Vector2(300*y,x*(1080/(Lanes+1))),Vector2(300*(y+1),(x+1)*(1080/(Lanes+1))),Color.BLACK,25)
			if PathDungeonLayout[y][x].contains("U"):
				draw_line(Vector2(300*y,x*(1080/(Lanes+1))),Vector2(300*(y+1),(x-1)*(1080/(Lanes+1))),Color.BLACK,25)
			if PathDungeonLayout[y][x].contains("R"):
				draw_line(Vector2(300*y,x*(1080/(Lanes+1))),Vector2(300*(y+1),x*(1080/(Lanes+1))),Color.BLACK,25)
			if PathDungeonLayout[y][x].contains("C"):
				draw_line(Vector2(300*y,x*(1080/(Lanes+1))),Vector2(300*(y+1),Lanes/2*(1080/(Lanes+1))),Color.BLACK,25)
