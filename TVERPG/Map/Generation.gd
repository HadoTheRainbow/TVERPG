extends Control

class_name DungeonRandomization
@onready var DungeonStats = $".."


@onready var g = DungeonStats.Lenght
func GenerateBasic(y,x):
	if y==DungeonStats.Lenght-1:
		DungeonStats.PathDungeonLayout[y][x] = "C"
		return "Converge"
	var roll = randi_range(0,6)
	print("roll: " + str(roll))
	var CrossroadRoll = randi_range(0,3)
	print("crossroadroll: " + str(CrossroadRoll))
	var SwapRoll = randi_range(0,1)
	var SwapRoll2 = randi_range(0,3)
	print("Swaproll: " + str(SwapRoll))
	print("Swaproll2: " + str(SwapRoll2))
	print(" ")
	if roll==4:
		roll=0
	if roll==5:
		roll=1
	if roll==6:
		roll=2
	match roll:
		0:  #CROSSROAD
			if x-1<0:
				CrossroadRoll=0
			elif x+1>=DungeonStats.Lanes-1:
				CrossroadRoll=2 
			elif DungeonStats.DungeonLayout[y+1][x+1]=="ConstructionRoom" or DungeonStats.DungeonLayout[y+1][x+2]=="ConstructionRoom":
				CrossroadRoll = 2
			elif DungeonStats.DungeonLayout[y+1][x-1]=="ConstructionRoom" or DungeonStats.DungeonLayout[y+1][x-2]=="ConstructionRoom":
				CrossroadRoll = 0
			elif DungeonStats.DungeonLayout[y+1][x]=="ConstructionRoom":
				CrossroadRoll = 1
			match CrossroadRoll:
				0: #DR
					DungeonStats.DungeonLayout[y+1][x+1] = "ConstructionRoom"
					DungeonStats.DungeonLayout[y+1][x] = "ConstructionRoom"
					DungeonStats.PathDungeonLayout[y][x] = "DR"
					print("DR")
				1: #DU
					DungeonStats.DungeonLayout[y+1][x+1] = "ConstructionRoom"
					DungeonStats.DungeonLayout[y+1][x-1] = "ConstructionRoom"
					DungeonStats.PathDungeonLayout[y][x] = "DU"
					print("DU")
				2: #UR
					DungeonStats.DungeonLayout[y+1][x] = "ConstructionRoom"
					DungeonStats.DungeonLayout[y+1][x-1] = "ConstructionRoom"
					DungeonStats.PathDungeonLayout[y][x] = "UR"
					print("UR")
				3: #DUR
					DungeonStats.DungeonLayout[y+1][x-1] = "ConstructionRoom"
					DungeonStats.DungeonLayout[y+1][x+1] = "ConstructionRoom"
					DungeonStats.DungeonLayout[y+1][x] = "ConstructionRoom"
					DungeonStats.PathDungeonLayout[y][x] = "DUR"
					print("DUR")
			return "Crossroad"
		1: # CORRIDOR  R
			DungeonStats.DungeonLayout[y+1][x] = "ConstructionRoom"
			DungeonStats.PathDungeonLayout[y][x] = "R"
			print("R")
			return "Corridor"
		2: # SWAP U or D
			if x+1>=DungeonStats.Lanes: # U
				DungeonStats.DungeonLayout[y+1][x-1] = "ConstructionRoom"
				DungeonStats.PathDungeonLayout[y][x] = "U"
				print("U")
			
			elif x-1<0: 
				DungeonStats.DungeonLayout[y+1][x+1] = "ConstructionRoom"
				DungeonStats.PathDungeonLayout[y][x] = "D"
				print("D")
			else:
				#if SwapRoll == 0: # D
					#if DungeonLayout[y+1][x+1]=="ConstructionRoom":
						#if SwapRoll2==0:
							#DungeonLayout[y+1][x+1] = "ConstructionRoom"
							#PathDungeonLayout[y][x] = "D"
							#print("D")
						#elif SwapRoll2!=0:
							#DungeonLayout[y+1][x-1] = "ConstructionRoom"
							#PathDungeonLayout[y][x] = "U"
							#print("U")
				
				if SwapRoll==0 and DungeonStats.DungeonLayout[y+1][x+1]=="ConstructionRoom" and SwapRoll2==0:
					DungeonStats.PathDungeonLayout[y][x] = "D"
					print("D")
				elif SwapRoll==0 and DungeonStats.DungeonLayout[y+1][x+1]=="ConstructionRoom" and SwapRoll2!=0:
					DungeonStats.DungeonLayout[y+1][x-1] = "ConstructionRoom"
					DungeonStats.PathDungeonLayout[y][x] = "U"
					print("U")
				elif SwapRoll==0 and DungeonStats.DungeonLayout[y+1][x+1]=="VoidRoom":
					DungeonStats.DungeonLayout[y+1][x+1] = "ConstructionRoom"
					DungeonStats.PathDungeonLayout[y][x] = "D"
					print("D")
				elif SwapRoll==1 and DungeonStats.DungeonLayout[y+1][x-1]=="ConstructionRoom" and SwapRoll2==0:
					DungeonStats.PathDungeonLayout[y][x] = "U"
					print("U")
				elif  SwapRoll==1 and DungeonStats.DungeonLayout[y+1 ][x-1]=="ConstructionRoom" and SwapRoll2!=0:
					DungeonStats.DungeonLayout[y+1][x+1] = "ConstructionRoom"
					DungeonStats.PathDungeonLayout[y][x] = "D"
					print("D")
				elif SwapRoll==1 and DungeonStats.DungeonLayout[y+1][x-1]=="VoidRoom":
					DungeonStats.DungeonLayout[y+1][x-1] = "ConstructionRoom"
					DungeonStats.PathDungeonLayout[y][x] = "U"
					print("U")
					#elif DungeonLayout[y+1][x+1]!="ConstructionRoom":
							#DungeonLayout[y+1][x+1] = "ConstructionRoom"
							#PathDungeonLayout[y][x] = "D"
							#print("D")
					#elif SwapRoll!=0: # U
						#if DungeonLayout[y+1][x-1]=="ConstructionRoom":
							#if SwapRoll2==0:
								#DungeonLayout[y+1][x-1] = "ConstructionRoom"
								#PathDungeonLayout[y][x] = "U"
								#print("U")
							#elif SwapRoll2!=0:
								#DungeonLayout[y+1][x+1] = "ConstructionRoom"
								#PathDungeonLayout[y][x] = "D"
								#print("D")
						#elif DungeonLayout[y+1][x-1]!="ConstructionRoom":
							#DungeonLayout[y+1][x-1] = "ConstructionRoom"
							#PathDungeonLayout[y][x] = "U"
							#print("U")
			return "Swap"
		3: # CONVERGE 
			if x!=3:
				DungeonStats.DungeonLayout[y+1][(DungeonStats.Lanes/2)] = "ConstructionRoom"
				DungeonStats.PathDungeonLayout[y][x] = "C"
				print("C")
				return "Converge"
			else:
				return GenerateBasic(y,x)
func GenerateBeginner(y,x):
	DungeonStats.Lenght = randi_range(3,5) + 4
	if DungeonStats.DungeonLayout[y][x] == "BeginningRoom":
		return "BeginningRoom"
	return "Corridor"
	


	
