extends Node2D

class_name DungeonGeneration
@onready var room: Node2D = $Room
@onready var Room:PackedScene = preload("res://Map/Room.tscn")


enum DungeonTypes {Beginning, ChamberOfCinders,Basic, Gimmick,Lenient,}
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
var t=false
@onready var DungeonRandomize = $GenerateDungeon
@onready var camera_2d = $Camera2D
@onready var sprite_2d = $BeginningRoom/Sprite2D
func Prep():
	
	sprite_2d.position = Vector2(0,((Lanes/2))*(1080/(Lanes+1)))
	sprite_2d.visible = true
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
	t=true
	
	
	DungeonLayout[0][Lanes/2]= "BeginningRoom" # if you want one path then comment out the 2 lines below this
	#DungeonLayout[0][Lanes/2+2]= "BeginningRoom"
	#DungeonLayout[0][Lanes/2]= "BeginningRoom"

func _on_generate_dungeon_pressed():
	match ChosenType:
		0: 
			Lenght = randi_range(3,5) + 4
			Lanes = 3
			Prep()
		1: 
			Lenght = randi_range(6,7)+3
			Lanes = 5
			Prep()
		2:Prep()
		
	for x in Lenght:
		for y in Lanes:
			match ChosenType:
				0: #Beginning Dungeon
					if y==Lanes/2:
						DungeonLayout[x][y] = DungeonRandomize.GenerateBeginner(x,y)
				1: # Chamber of Cinders
					
					match DungeonLayout[x][y]:
						"BeginningRoom":
							PathDungeonLayout[0][Lanes/2]="URD"
							DungeonLayout[x+1][y]="ConstructionRoom"
							DungeonLayout[x+1][y+1]="ConstructionRoom"
							DungeonLayout[x+1][y-1]="ConstructionRoom"
						"ConstructionRoom":
							DungeonLayout[x][y] = DungeonRandomize.Generate(x,y)
				2: #Basic dungeon
					match DungeonLayout[x][y]:
						"BeginningRoom":
							PathDungeonLayout[0][Lanes/2]="URD"
							DungeonLayout[x+1][y]="ConstructionRoom"
							DungeonLayout[x+1][y+1]="ConstructionRoom"
							DungeonLayout[x+1][y-1]="ConstructionRoom"
						"ConstructionRoom":
							DungeonLayout[x][y] = DungeonRandomize.Generate(x,y)
				3:
					pass
				4:
					pass
			#for z in Lenght:
				#print(DungeonLayout[z])
			#print("")
	#for y in Lenght:
		#print(DungeonLayout[y])
	for x in Lenght:
		for y in Lanes:
			match DungeonLayout[x][y]: # Instantiates the Pathways
				"Corridor": 
					NodeDungeonLayout[x][y] = Corridor.instantiate()
					add_child(NodeDungeonLayout[x][y])
					NodeDungeonLayout[x][y].Position(x,y,Lanes)
				"Crossroad": 
					NodeDungeonLayout[x][y] = Crossroad.instantiate()
					add_child(NodeDungeonLayout[x][y])
					NodeDungeonLayout[x][y].Position(x,y,Lanes)
				"Swap": 
					NodeDungeonLayout[x][y] = Swap.instantiate()
					add_child(NodeDungeonLayout[x][y])
					NodeDungeonLayout[x][y].Position(x,y,Lanes)
				"Converge": 
					NodeDungeonLayout[x][y] = Converge.instantiate()
					add_child(NodeDungeonLayout[x][y])
					NodeDungeonLayout[x][y].Position(x,y,Lanes)
	queue_redraw()
	for x in Lenght:
		for y in Lanes:
			if DungeonLayout[x][y]!="VoidRoom":  #Instantiates the rooms
				RoomDungeonLayout[x][y] = room.GenerateRoom(ChosenType,x)
				match RoomDungeonLayout[x][y]:
					"Encounter":
						RoomNodeDungeonLayout[x][y] = Room.instantiate()
						add_child(RoomNodeDungeonLayout[x][y])
						RoomNodeDungeonLayout[x][y].InstantiateTexture(x,y,"Encounter")
						RoomNodeDungeonLayout[x][y].Position(x,y,Lanes)
					"FormidableEncounter":
						RoomNodeDungeonLayout[x][y] = Room.instantiate()
						add_child(RoomNodeDungeonLayout[x][y])
						RoomNodeDungeonLayout[x][y].InstantiateTexture(x,y,"FormidableEncounter")
						RoomNodeDungeonLayout[x][y].Position(x,y,Lanes)
					"OminousEncounter":
						RoomNodeDungeonLayout[x][y] = Room.instantiate()
						add_child(RoomNodeDungeonLayout[x][y])
						RoomNodeDungeonLayout[x][y].InstantiateTexture(x,y,"OminousEncounter")
						RoomNodeDungeonLayout[x][y].Position(x,y,Lanes)
					"BossEncounter":
						RoomNodeDungeonLayout[x][y] = Room.instantiate()
						add_child(RoomNodeDungeonLayout[x][y])
						RoomNodeDungeonLayout[x][y].InstantiateTexture(x,y,"BossEncounter")
						RoomNodeDungeonLayout[x][y].Position(x,y,Lanes)
					"Shop":
						RoomNodeDungeonLayout[x][y] = Room.instantiate()
						add_child(RoomNodeDungeonLayout[x][y])
						RoomNodeDungeonLayout[x][y].InstantiateTexture(x,y,"Shop")
						RoomNodeDungeonLayout[x][y].Position(x,y,Lanes)
					"Treasure":
						RoomNodeDungeonLayout[x][y] = Room.instantiate()
						add_child(RoomNodeDungeonLayout[x][y])
						RoomNodeDungeonLayout[x][y].InstantiateTexture(x,y,"Treasure")
						RoomNodeDungeonLayout[x][y].Position(x,y,Lanes)
					"GrandTreasure":
						RoomNodeDungeonLayout[x][y] = Room.instantiate()
						add_child(RoomNodeDungeonLayout[x][y])
						RoomNodeDungeonLayout[x][y].InstantiateTexture(x,y,"GrandTreasure")
						RoomNodeDungeonLayout[x][y].Position(x,y,Lanes)
					"HealingFountain":
						RoomNodeDungeonLayout[x][y] = Room.instantiate()
						add_child(RoomNodeDungeonLayout[x][y])
						RoomNodeDungeonLayout[x][y].InstantiateTexture(x,y,"HealingFountain")
						RoomNodeDungeonLayout[x][y].Position(x,y,Lanes)
					"Idol":
						RoomNodeDungeonLayout[x][y] = Room.instantiate()
						add_child(RoomNodeDungeonLayout[x][y])
						RoomNodeDungeonLayout[x][y].InstantiateTexture(x,y,"Idol")
						RoomNodeDungeonLayout[x][y].Position(x,y,Lanes)
					"Checkpoint":
						RoomNodeDungeonLayout[x][y] = Room.instantiate()
						add_child(RoomNodeDungeonLayout[x][y])
						RoomNodeDungeonLayout[x][y].InstantiateTexture(x,y,"Checkpoint")
						RoomNodeDungeonLayout[x][y].Position(x,y,Lanes)
					"Invisible":
						RoomNodeDungeonLayout[x][y] = Room.instantiate()
						add_child(RoomNodeDungeonLayout[x][y])
						RoomNodeDungeonLayout[x][y].InstantiateTexture(x,y,"Invisible")
						RoomNodeDungeonLayout[x][y].Position(x,y,Lanes)
					
	for y in Lenght:
		print(DungeonLayout[y])







func _draw():
	if t==true:
		for x in Lenght:
			for y in Lanes:
				if PathDungeonLayout[x][y].contains("D"):
					draw_line(Vector2(300*x,y*(1080/(Lanes+1))),Vector2(300*(x+1),(y+1)*(1080/(Lanes+1))),Color.BLACK,25)
				if PathDungeonLayout[x][y].contains("U"):
					draw_line(Vector2(300*x,y*(1080/(Lanes+1))),Vector2(300*(x+1),(y-1)*(1080/(Lanes+1))),Color.BLACK,25)
				if PathDungeonLayout[x][y].contains("R"):
					draw_line(Vector2(300*x,y*(1080/(Lanes+1))),Vector2(300*(x+1),y*(1080/(Lanes+1))),Color.BLACK,25)
				if PathDungeonLayout[x][y].contains("C"):
					draw_line(Vector2(300*x,y*(1080/(Lanes+1))),Vector2(300*(x+1),Lanes/2*(1080/(Lanes+1))),Color.BLACK,25)
