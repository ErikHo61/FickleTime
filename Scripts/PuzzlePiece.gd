extends Area2D

var img1 = preload("res://.import/PlantPuzzle6.png-882751d0c4a9391d38ef83c42e7018d5.stex")
var img2 = preload("res://.import/redveg.png-91ce44707306b6a9c08d5f76271c9e27.stex")
var img3 = preload("res://.import/turnip.png-8fdd3a426dfebc4b0a788cb0415e3d60.stex")
var img4 = preload("res://.import/plant8.png-4ed0f5da6d943010eb724d6f9be4e281.stex")
var img5 = preload("res://.import/plant2.png-2bbc55594ad52f1a6ca30f41fd3d8e38.stex")
var img6 = preload("res://.import/plant1.png-a9a525e1ffb1c5afece4ae59a02df368.stex")
var img7 = preload("res://.import/greenveg.png-9b5b6162144622f3cce7e7686fa3c080.stex")
var img8 = preload("res://.import/fishyellow.png-0aa7e7c4a14a10324ca940482ebfe7ee.stex") 
var img9 = preload("res://.import/fishblue.png-5582c08f104bb1a1faebc44fe2d470f0.stex") 
var img10 = preload("res://.import/drumstick.png-5e2aef812b9f22baa170fc0008ffb28e.stex")
var img11 = preload("res://.import/carrotveg.png-9079144acc897d5902eee3e6d5bb701d.stex")


var id:int
var element = "none"
var attributes = []
var piece_name = ""
#if item does exist in the past
var past_only = false
var picked_up = false

func _ready():
	Global.connect("in_past_changed", self, "_timeVisible")
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	past_only = bool(rng.randi_range(0, 1))
	if(past_only):
		visible = false
	pass

func _timeVisible(player_in_past):
	if(!picked_up):
		if(!past_only): # if item doesn't exist in the past
			if(player_in_past):
				visible = false
			else:
				visible = true
		else:
			if(player_in_past):
				visible = true
			else:
				visible = false
		

func randomize_sprite():
	var sprites = [img1, img2, img3, img4, img5, img6, img7, img8, img9, img10, img11]
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var chosen_sprite = sprites[rng.randi() % sprites.size()]
	$Sprite.texture = chosen_sprite
	pass

#provides puzzlepiece with a random set of attributes
#must have the required element
func initAttributes(requiredElement = "random"):
	var dict = {}
	dict["paper"] = ["fire", "water", "cut"]
	dict["plant"] = ["fire", "water", "cut"]
	dict["veg"] = ["fire", "water", "cut"]
	dict["wood"] = ["fire", "water", "cut"]
	dict["towel"] = ["water", "air"]
	dict["metal"] = ["fire", "electric", "cut"]
	dict["circuit"] = ["water", "electric", "cut"]
	dict["fish"] = ["fire", "electric", "cut"]
	dict["lamp"] = ["electric"]
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	if(requiredElement == "random" || requiredElement == "none"):
		var randKey = dict.keys()[rng.randi() % dict.keys().size()]
		piece_name = randKey
		print("Chosen Object: " + randKey)
		attributes = dict[randKey]
		
		return
	else:
		var pot = []
		for key in dict.keys():
			if(dict[key].has(requiredElement)):
				pot.append(key)
		var randKey = pot[rng.randi() % pot.size()]
		piece_name = randKey
		print("Chosen Object: " + randKey)
		attributes = dict[randKey]
		
	
	pass
	
func _on_PuzzlePiece_body_entered(body):
	if(!picked_up):
		if(visible):
			print("Player gained piece " + str(id) + " " + piece_name)
			Global.puzzle_Inventory[id] = self
			self.visible = false
			if(Global.in_past):
				picked_up = true
	pass # Replace with function body.

func destruct():
	queue_free()
