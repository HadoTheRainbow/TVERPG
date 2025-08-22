extends Control

class_name DungeonRandomization
@onready var DungeonStats = $".."


var g 
func Generate(x,y) -> String:
	if x+2==DungeonStats.Lenght:
		DungeonStats.PathDungeonLayout[x][y] = "C"
		DungeonStats.DungeonLayout[DungeonStats.Lenght-1][DungeonStats.Lanes/2] = "ConstructionRoom"
		return "Converge"
	elif x+1==DungeonStats.Lenght:
		DungeonStats.PathDungeonLayout[x][y] = "R"
		return "Corridor"
	var roll = randi_range(0,6)
	print("roll: " + str(roll))
	var CrossroadRoll = randi_range(0,3)
	print("crossroadroll: " + str(CrossroadRoll))
	var SwapRoll = randi_range(0,1)
	print("Swaproll: " + str(SwapRoll))
	var SwapRoll2 = randi_range(0,3)
	print("Swaproll2: " + str(SwapRoll2))
	var Roll2 = randi_range(1,5)
	print("Roll2: " + str(Roll2))
	print(" ")
	if(x> DungeonStats.Lenght/3 and x<(DungeonStats.Lenght/3)*2):
		if Roll2==1:
			roll=4
		elif Roll2==2 or Roll2==3:
			roll=5
		else:
			roll=6
	if roll==4:
		roll=0
	if roll==5:
		roll=1
	if roll==6:
		roll=2
	match roll:
		0:  #CROSSROAD
			if y-1<0:
				CrossroadRoll=0
			elif y+1==DungeonStats.Lanes:
				CrossroadRoll=2 
			elif DungeonStats.DungeonLayout[x+1][y+1]=="ConstructionRoom":# or DungeonStats.DungeonLayout[x+1][y+2]=="ConstructionRoom":
				CrossroadRoll = 2
			elif DungeonStats.DungeonLayout[x+1][y-1]=="ConstructionRoom":# or DungeonStats.DungeonLayout[x+1][y-2]=="ConstructionRoom":
				CrossroadRoll = 0
			elif DungeonStats.DungeonLayout[x+1][y]=="ConstructionRoom":
				CrossroadRoll = 1
			match CrossroadRoll:
				0: #DR
					DungeonStats.DungeonLayout[x+1][y+1] = "ConstructionRoom"
					DungeonStats.DungeonLayout[x+1][y] = "ConstructionRoom"
					DungeonStats.PathDungeonLayout[x][y] = "DR"
					print("DR")
				1: #DU
					DungeonStats.DungeonLayout[x+1][y+1] = "ConstructionRoom"
					DungeonStats.DungeonLayout[x+1][y-1] = "ConstructionRoom"
					DungeonStats.PathDungeonLayout[x][y] = "DU"
					print("DU")
				2: #UR
					DungeonStats.DungeonLayout[x+1][y] = "ConstructionRoom"
					DungeonStats.DungeonLayout[x+1][y-1] = "ConstructionRoom"
					DungeonStats.PathDungeonLayout[x][y] = "UR"
					print("UR")
				3: #DUR
					DungeonStats.DungeonLayout[x+1][y-1] = "ConstructionRoom"
					DungeonStats.DungeonLayout[x+1][y+1] = "ConstructionRoom"
					DungeonStats.DungeonLayout[x+1][y] = "ConstructionRoom"
					DungeonStats.PathDungeonLayout[x][y] = "DUR"
					print("DUR")
			return "Crossroad"
		1: # CORRIDOR  x
			DungeonStats.DungeonLayout[x+1][y] = "ConstructionRoom"
			DungeonStats.PathDungeonLayout[x][y] = "R"
			print("R")
			return "Corridor"
		2: # SWAP U or D
			if y+1>=DungeonStats.Lanes: # U
				DungeonStats.DungeonLayout[x+1][y-1] = "ConstructionRoom"
				DungeonStats.PathDungeonLayout[x][y] = "U"
				print("U")
			
			elif y-1<0: 
				DungeonStats.DungeonLayout[x+1][y+1] = "ConstructionRoom"
				DungeonStats.PathDungeonLayout[x][y] = "D"
				print("D")
			else:
				#if SwapRoll == 0: # D
					#if DungeonLayout[x+1][y+1]=="ConstructionRoom":
						#if SwapRoll2==0:
							#DungeonLayout[x+1][y+1] = "ConstructionRoom"
							#PathDungeonLayout[x][y] = "D"
							#print("D")
						#elif SwapRoll2!=0:
							#DungeonLayout[x+1][y-1] = "ConstructionRoom"
							#PathDungeonLayout[x][y] = "U"
							#print("U")
				
				if SwapRoll==0 and DungeonStats.DungeonLayout[x+1][y+1]=="ConstructionRoom" and SwapRoll2==0:
					DungeonStats.PathDungeonLayout[x][y] = "D"
					print("D")
				elif SwapRoll==0 and DungeonStats.DungeonLayout[x+1][y+1]=="ConstructionRoom" and SwapRoll2!=0:
					DungeonStats.DungeonLayout[x+1][y-1] = "ConstructionRoom"
					DungeonStats.PathDungeonLayout[x][y] = "U"
					print("U")
				elif SwapRoll==0 and DungeonStats.DungeonLayout[x+1][y+1]=="VoidRoom":
					DungeonStats.DungeonLayout[x+1][y+1] = "ConstructionRoom"
					DungeonStats.PathDungeonLayout[x][y] = "D"
					print("D")
				elif SwapRoll==1 and DungeonStats.DungeonLayout[x+1][y-1]=="ConstructionRoom" and SwapRoll2==0:
					DungeonStats.PathDungeonLayout[x][y] = "U"
					print("U")
				elif  SwapRoll==1 and DungeonStats.DungeonLayout[x+1 ][y-1]=="ConstructionRoom" and SwapRoll2!=0:
					DungeonStats.DungeonLayout[x+1][y+1] = "ConstructionRoom"
					DungeonStats.PathDungeonLayout[x][y] = "D"
					print("D")
				elif SwapRoll==1 and DungeonStats.DungeonLayout[x+1][y-1]=="VoidRoom":
					DungeonStats.DungeonLayout[x+1][y-1] = "ConstructionRoom"
					DungeonStats.PathDungeonLayout[x][y] = "U"
					print("U")
					#elif DungeonLayout[x+1][y+1]!="ConstructionRoom":
							#DungeonLayout[x+1][y+1] = "ConstructionRoom"
							#PathDungeonLayout[x][y] = "D"
							#print("D")
					#elif SwapRoll!=0: # U
						#if DungeonLayout[x+1][y-1]=="ConstructionRoom":
							#if SwapRoll2==0:
								#DungeonLayout[x+1][y-1] = "ConstructionRoom"
								#PathDungeonLayout[x][y] = "U"
								#print("U")
							#elif SwapRoll2!=0:
								#DungeonLayout[x+1][y+1] = "ConstructionRoom"
								#PathDungeonLayout[x][y] = "D"
								#print("D")
						#elif DungeonLayout[x+1][y-1]!="ConstructionRoom":
							#DungeonLayout[x+1][y-1] = "ConstructionRoom"
							#PathDungeonLayout[x][y] = "U"
							#print("U")
			return "Swap"
			
			
		3: # CONVERGE 
			if y!=3:
				DungeonStats.DungeonLayout[x+1][(DungeonStats.Lanes/2)] = "ConstructionRoom"
				DungeonStats.PathDungeonLayout[x][y] = "C"
				print("C")
				return "Converge"
			else:
				return Generate(x,y)
	return "VoidRoom"
func GenerateBeginner(x,y) -> String:
	
	if DungeonStats.DungeonLayout[x][y] == "BeginningRoom":
		return "BeginningRoom"
	return "Corridor"


	
	


	
