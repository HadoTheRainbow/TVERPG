extends Node2D
@export var Pos : int
@export var Lane : int
@export var CanTravel : bool
@onready var corridor = $"."

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func Position(x,y,Lanes):
	Pos = y
	Lane = x
	position = Vector2(x*300,y*(1080/(Lanes+1)))
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
