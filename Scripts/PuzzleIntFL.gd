extends Area2D

var in_chest_zone = false
var requiredKeyIDs = []
var currentIndex = 0
var coupleID

func _ready():
	pass
	
func initFirstPiece():
	Global.nextPuzzlePieceFL(requiredKeyIDs[currentIndex])

func _process(delta):
	if(in_chest_zone && Input.is_action_just_pressed("ui_accept")):
		if(Global.checkPuzzlePieces([requiredKeyIDs[currentIndex]])):
			if(currentIndex == requiredKeyIDs.size()-1):
				print("Played gained key# " + str(coupleID))
				Global.key_found[coupleID] = true
				queue_free()
			else:
				currentIndex+=1
				print("next Index " + str(currentIndex))
				print("find me: "+ str(requiredKeyIDs[currentIndex]))
				Global.nextPuzzlePieceFL(requiredKeyIDs[currentIndex])
	pass



func _on_PuzzleIntFL_body_entered(body):
	in_chest_zone = true
	pass # Replace with function body.


func _on_PuzzleIntFL_body_exited(body):
	in_chest_zone = false
	pass # Replace with function body.
