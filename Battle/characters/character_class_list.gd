extends Node
class_name CharacterList

var display: String
const DISPLAYS = [
        ["kat battle 1"],
        ["red battle 1"],
        ["yeet battle 1"],
        ["zynth battle 1"],
        ["hado battle 1"],
        ["skeletongeneric battle 1"],
        ["fireslime battle 1"],
        ["storm princess battle 1"],





    ]
func _init(id):
    display = DISPLAYS[id][0]
