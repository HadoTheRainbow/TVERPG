extends Node2D
@export var Pos : int
@export var Lane : int
@export var CanTravel : bool

func Position(x,y,Lanes):
	Pos = y
	Lane = x
	position = Vector2(x*300,y*(1080/(Lanes+1)))
