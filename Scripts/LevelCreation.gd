extends TileMap

export(Dictionary) var TILE_SCENES := {
	"k":preload("res://Scenes/key.tscn"),
	"l":preload("res://Scenes/Door.tscn"),
	"pi":preload("res://Scenes/PuzzleInt.tscn"),
	"pp":preload("res://Scenes/PuzzlePiece.tscn"),
	"g":preload("res://Scenes/Gate.tscn"),
	"tp":preload("res://Scenes/Portal.tscn"),
	"ppfl":preload("res://Scenes/PuzzlePieceFL.tscn"),
	"pifl":preload("res://Scenes/PuzzleIntFL.tscn")
}
var tiles
#
var placedKeyNodes= []
var bannedKeyIDs = {}
#An array of Puzzle Interactable scenes
var puzzleInts = []
#An array of Puzzle Pieces scenes
var puzzlePieces = []

var puzzle_reward = []
var door_pairs = []

var puzzleIntFL = []

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

func initTiles(ti):
	tiles = ti
	_placeEnvironment()
	_setPuzzleProperties()
	_initPastDoors()
	_initPIFL()

func _placeEnvironment():
	for n in tiles.size():
		match(tiles[n].type):
			"floor":
				set_cell(tiles[n].x, tiles[n].y, 0)
			"empty":
				set_cell(tiles[n].x, tiles[n].y, 10)
			"wall":
				set_cell(tiles[n].x, tiles[n].y, 11)
			"l", "lm":
				#set_cell(tiles[n].x, tiles[n].y, 8)
				var door = TILE_SCENES["l"].instance().duplicate()
				door.position = Vector2(tiles[n].x*16, tiles[n].y*16)
				for child in tiles[n].actChildren:
					door.keyIDs.append(int(child))
				addDoor(door)
				add_child(door)
				
			"k", "km":
				set_cell(tiles[n].x, tiles[n].y, 0)
				if(!bannedKeyIDs.has(tiles[n].graphID)):				
					var key = TILE_SCENES["k"].instance()
					key.id = tiles[n].graphID
					key.position = Vector2(tiles[n].x*16, tiles[n].y*16)
					add_child(key)
					#roundabout method of providing key as reward
					placedKeyNodes.append(key)
			"tp":
				set_cell(tiles[n].x, tiles[n].y, 0)
				var portal = TILE_SCENES["tp"].instance()
				portal.position = Vector2(tiles[n].x*16, tiles[n].y*16)
				add_child(portal)
			
			"pr":
				set_cell(tiles[n].x, tiles[n].y, 0)
				#These are the product of pi that add element
				puzzle_reward.append(tiles[n].graphID)
				
			"pp":
				set_cell(tiles[n].x, tiles[n].y, 0)
				var pp = TILE_SCENES["pp"].instance()
				pp.id = tiles[n].graphID
				pp.randomize_sprite()
				pp.position = Vector2(tiles[n].x*16, tiles[n].y*16)
				add_child(pp)
				puzzlePieces.append(pp)
			"pi":
				set_cell(tiles[n].x, tiles[n].y, 0)
				var pi = TILE_SCENES["pi"].instance()
				pi.position = Vector2(tiles[n].x*16, tiles[n].y*16)
				pi.randomize_sprite()
				pi.coupleID = tiles[n].coupleID
				for child in tiles[n].actChildren:
					pi.requiredKeyIDs.append(int(child))			
				add_child(pi)
				puzzleInts.append(pi)
				
				#roundabout implementation of providing key as reward
				_removeKey(tiles[n].coupleID)
				bannedKeyIDs[tiles[n].coupleID] = true
			
			"pifl":
				set_cell(tiles[n].x, tiles[n].y, 0)
				var pi = TILE_SCENES["pifl"].instance()
				pi.position = Vector2(tiles[n].x*16, tiles[n].y*16)
				pi.coupleID = tiles[n].coupleID
				for child in tiles[n].actChildren:
					pi.requiredKeyIDs.append(int(child))		
				add_child(pi)
				puzzleIntFL.append(pi)
				
				#roundabout implementation of providing key as reward
				_removeKey(tiles[n].coupleID)
				bannedKeyIDs[tiles[n].coupleID] = true
			"ppfl":
				set_cell(tiles[n].x, tiles[n].y, 0)
				var pp = TILE_SCENES["ppfl"].instance()
				pp.id = tiles[n].graphID
				pp.position = Vector2(tiles[n].x*16, tiles[n].y*16)
				add_child(pp)
				puzzlePieces.append(pp)
			"g":
				set_cell(tiles[n].x, tiles[n].y, 0)
				print("you win the game")
				var g = TILE_SCENES["g"].instance()
				g.position = Vector2(tiles[n].x*16, tiles[n].y*16)
				add_child(g)
			_:
				set_cell(tiles[n].x, tiles[n].y, 0)
			
	pass
	
func _initPastDoors():
	for doorArray in door_pairs:
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var boolPast = bool(rng.randi_range(0, 1))
		doorArray[0].past_only = boolPast
		doorArray[1].past_only = boolPast
		
func addDoor(doorNode):
	var matching = false
	for doorArray in door_pairs:
		if(doorArray[0].keyIDs == doorNode.keyIDs):
			print("Found one")
			doorArray.append(doorNode)
			return
	door_pairs.append([doorNode])
	print("didnt find one")

func _initPIFL():
	for pifl in puzzleIntFL:
		pifl.initFirstPiece()
		
func _setPuzzleProperties():
	Global.puzzleInts = puzzleInts
	Global.puzzlePieces = puzzlePieces
	
	#puzzleInts need to add property
	for pi in puzzleInts:
		if(puzzle_reward.has(pi.coupleID)):
			var ele = pi.initElement();
			print("chosen element " + ele)
			for pp in puzzlePieces:
				for id in pi.requiredKeyIDs:
					if(pp.id == id):
						pp.initAttributes(ele)
		
	#puzzlePieces need to have attributes. 
	#find out which puzzleInt has a coupleNode that is a pr?	
	#
	pass


func _removeKey(id):
	for keyNode in placedKeyNodes:
		if(keyNode.id == id):
			print("removed key "+ str(id))
			remove_child(keyNode)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
