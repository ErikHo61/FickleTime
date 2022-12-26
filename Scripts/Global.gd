extends Node2D

signal in_past_changed(new_val)
signal activate_next_pieceFL(id)
#key inventory
export var key_found = {}

#Dictionary of id to arrays. can contain bools instead of puzzle piece node
export var puzzle_Inventory = {}
#currentIndex of the puzzle inventory. Determines which puzzle piece to interact with puzzle interactable
var currentIndex = 0

#An array of Puzzle Interactable scenes unused
var puzzleInts = []
#An array of Puzzle Pieces scenes
var puzzlePieces = []

var in_past = false

func _ready():
	pass

func switchTime():
	if(in_past):
		in_past = false
		print("moving to the present")
		get_tree().get_root().get_node("Main").modulate = Color(1.0, 1.0, 1.0)
	else:
		in_past = true
		print("moving to the past")
		get_tree().get_root().get_node("Main").modulate = Color(0.77, 1.0, 1.0)
	emit_signal("in_past_changed", in_past)

func nextPuzzlePieceFL(id):
	emit_signal("activate_next_pieceFL", id)
	
func checkKeys(doorKeys):
	for key in doorKeys:
		print("need " + str(key))
	return key_found.has_all(doorKeys)

func checkPuzzlePieces(requiredIDs):
	for id in requiredIDs:
		print("need " + str(id))
	return puzzle_Inventory.has_all(requiredIDs)
		
func checkAttribute(requiredAttribute):
	print("need attribute " + requiredAttribute)
	if(puzzle_Inventory.empty()):
		return false
	if(typeof(puzzle_Inventory.values()[currentIndex]) ==TYPE_BOOL):
		return false
	return puzzle_Inventory.values()[currentIndex].attributes.has(requiredAttribute)
	
func set_current_piece_element(element):
	if(typeof(puzzle_Inventory.values()[currentIndex]) ==TYPE_BOOL):
		return
	puzzle_Inventory.values()[currentIndex].element = element
	
func nextIndex():
	if(typeof(puzzle_Inventory.values()[currentIndex]) ==TYPE_BOOL):
		currentIndex =puzzle_Inventory.values().size()-1
		print("next piece " + str(puzzle_Inventory.keys()[currentIndex]))
		return
	elif(currentIndex >= puzzle_Inventory.values().size()):
		currentIndex =puzzle_Inventory.values().size()-1
		print("next piece " + str(puzzle_Inventory.values()[currentIndex].id))
	elif(puzzle_Inventory.values().size() != 0):
		currentIndex = (currentIndex +1) % puzzle_Inventory.values().size()
		print("next piece " + str(puzzle_Inventory.values()[currentIndex].id))
	
func _refreshIndex():
	if(currentIndex >= puzzle_Inventory.values().size()):
		currentIndex =puzzle_Inventory.values().size()-1
		
func removePuzzlePiece(id):
	if(typeof(puzzle_Inventory[id]) != TYPE_BOOL):
		puzzle_Inventory[id].destruct()
	puzzle_Inventory.erase(id)
	_refreshIndex()
