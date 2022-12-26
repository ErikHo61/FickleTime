extends Area2D

var img1 = preload("res://.import/PlantPuzzle1.png-be7309b6502dc993f79f2c0528e11f0c.stex")
var img2 = preload("res://.import/PlantPuzzle2.png-483fdca042c992ae02e09a260d932975.stex")
var img3 = preload("res://.import/rock-cave.png-6b828562d871a0059cbef2ad71247579.stex")
var img4 = preload("res://.import/PlantPuzzle7.png-2259a37c0a34a831ac32599709c7daf9.stex")
var img5 = preload("res://.import/barrel.png-00c8a845764f3a98e1e6fb4a6e8b444e.stex")
var img6 = preload("res://.import/box-cave.png-53b42b0705b32136a40b08af3727cdd8.stex")

var in_chest_zone = false
var requiredKeyIDs = []
var coupleID
var addElement = "none" # "fire" "water" "air" "electric" "cut"
var elements = ["none", "fire", "water", "air", "electric", "cut"]


func _ready():
	pass

func randomize_sprite():
	var sprites = [img1, img2, img3, img4, img5, img6]
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var chosen_sprite = sprites[rng.randi() % sprites.size()]
	$Sprite.texture = chosen_sprite
	pass

func initElement():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	addElement = elements[rng.randi() % elements.size()]
	return addElement
	
func _process(delta):
	if(in_chest_zone):
		if(Input.is_action_just_pressed("ui_accept")):
			if(addElement != "none" && Global.checkAttribute(addElement)
			&& Global.checkPuzzlePieces(requiredKeyIDs)):
				#Global.set_current_piece_element(addElement)
				Global.puzzle_Inventory[coupleID] = true
				print("Added " + addElement + " element")
				print("Player gained piece# " + str(coupleID))
				for id in requiredKeyIDs:
					Global.removePuzzlePiece(id)
				queue_free()
			elif(addElement == "none" && Global.checkPuzzlePieces(requiredKeyIDs)):
				Global.key_found[coupleID] = true
				Global.puzzle_Inventory[coupleID] = true
				print("Player gained key# " + str(coupleID))
				for id in requiredKeyIDs:
					Global.removePuzzlePiece(id)
				queue_free()
				
				
	pass

func _on_Area2D_body_entered(body):
	in_chest_zone = true
	pass # Replace with function body.


func _on_Area2D_body_exited(body):
	in_chest_zone = false
	pass # Replace with function body.
