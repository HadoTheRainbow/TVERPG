extends Node2D
@export var Lenght : int
@export var Lanes : int
@onready var Crossroad :PackedScene = preload("res://Map/Crossroad.tscn")
@onready var Swap :PackedScene = preload("res://Map/Swap.tscn")
@onready var Corridor :PackedScene = preload("res://Map/Corridor.tscn")
@onready var Converge :PackedScene = preload("res://Map/Converge.tscn")
#Has the Lenght
var DungeonLayout = []
var PathDungeonLayout = []
var NodeDungeonLayout = []
var Corridor1
var Crossroad1
var Swap1
var Converge1
@onready var camera_2d = $Camera2D
@onready var sprite_2d = $BeginningRoom/Sprite2D

func _ready():
	sprite_2d.position = Vector2(0,(1080/Lanes)*2)
	#sprite_2d.apply_scale(Vector2(1.365/Lanes,1.365/Lanes))
	for x in Lenght:
		DungeonLayout.append([])
		PathDungeonLayout.append([])
		NodeDungeonLayout.append([])
		for y in Lanes:
			DungeonLayout[x].append("VoidRoom") 
			PathDungeonLayout[x].append(" ") 
			NodeDungeonLayout[x].append(" ") 
	
	#
	DungeonLayout[0][Lanes/2]= "BeginningRoom" # if you want one path then comment out the 2 lines below this
	DungeonLayout[0][Lanes/2+1]= "BeginningRoom"
	DungeonLayout[0][Lanes/2-1]= "BeginningRoom"
	for x in Lenght:
		print(DungeonLayout[x])
		print(x)
	
# 0 = Crossroad
# 1 = Corridor
# 2 = Swap
# 3 = Converge
# CROSSROAD: 
# 0 = /_   1 = / \ 2 = _\ 3 = /_\        
# 0 = up and equal 1 = Up and Down  2 = equal and down  3 = all 3
func DungeonRandomization(x,y):
	if y==Lenght-1:
		return "Corridor"
	else:
		var roll = randi_range(0,3)
		print("roll: " + str(roll))
		var Crossroad = randi_range(0,3)
		print("crossroad: " + str(Crossroad))
		var Swap = randi_range(0,1)
		print("Swap: " + str(Swap))
		match roll:
			0:  #CROSSROAD
				if x-1<Lanes:
					Crossroad=2
				elif x+1>Lanes:
					Crossroad =0 
				match Crossroad:
					0: #DR
						DungeonLayout[y+1][x+1] = "ConstructionRoom"
						DungeonLayout[y+1][x] = "ConstructionRoom"
					1: #DU
						DungeonLayout[y+1][x+1] = "ConstructionRoom"
						DungeonLayout[y+1][x-1] = "ConstructionRoom"
					2: #UR
						DungeonLayout[y+1][x] = "ConstructionRoom"
						DungeonLayout[y+1][x-1] = "ConstructionRoom"
					3: #URD
						DungeonLayout[y+1][x-1] = "ConstructionRoom"
						DungeonLayout[y+1][x+1] = "ConstructionRoom"
						DungeonLayout[y+1][x] = "ConstructionRoom"
				return "Crossroad"
			1: # CORRIDOR  R
				DungeonLayout[y+1][x] = "ConstructionRoom"
				return "Corridor"
			2: # SWAP U or D
				if x+1>=Lanes: # U
					DungeonLayout[y+1][x-1] = "ConstructionRoom"
				elif x-1<=Lanes: 
					DungeonLayout[y+1][x+1] = "ConstructionRoom"
				else:
					if Swap == 0: # D
						DungeonLayout[y+1][x+1] = "ConstructionRoom"
					else: # U
						DungeonLayout[y+1][x-1] = "ConstructionRoom"
				return "Swap"
			3: # CONVERGE 
				DungeonLayout[y+1][Lanes/2] = "ConstructionRoom"
				return "Converge"
			

func _on_generate_dungeon_pressed():
	for y in Lenght:
		for x in Lanes:
			#print(str(y) + " " + str(x))
			match DungeonLayout[y][x]:
				"BeginningRoom":
					DungeonLayout[y+1][x]="ConstructionRoom"
					DungeonLayout[y+1][x+1]="ConstructionRoom"
					DungeonLayout[y+1][x-1]="ConstructionRoom"
				"ConstructionRoom":DungeonLayout[y][x] = DungeonRandomization(x,y)
			for z in Lenght:
				print(DungeonLayout[z])
			print("")
	for x in Lenght:
		print(DungeonLayout[x])
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
					
