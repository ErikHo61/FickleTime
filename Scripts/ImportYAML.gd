extends TextureRect

signal tiles_imported_ready

var fp = "C:/Users/Erik/Documents/FickleTime/Levels/procgen.yaml"
#Has Converters and not at all small
var fp2 = "C:/Users/Erik/Documents/FickleTime/Levels/StartSmall2.yaml"
var fp3 = "C:/Users/Erik/Documents/FickleTime/Levels/RecipeLoop.yaml"
var fp4 = "C:/Users/Erik/Documents/FickleTime/Levels/RecipeMulti.yaml"
var allTiles =[]
var allObjects = []
#var maple = "maple"

class TileInfo:
	var type: String
	var uid: int
	var x: int
	var y: int
	var graphID: int
	var coupleID: int
	var actChildren = []
	
#var yaml = preload("res://addons/godot-yaml/gdyaml.gdns").new()
# Called when the node enters the scene tree for the first time.
func _ready():
	var filepath = fp
	#var filepath2 =  "C:/Users/Erik/Documents/FickleTime/Levels/test.txt"
	var content = loadfile(filepath)
	allTiles = readContents(content.split("\n"))
	allObjects = GetObjects(allTiles)
	
	$TileMap.initTiles(allTiles)
	
	var playerPos
	for n in allObjects.size():
		if(allObjects[n].type == "e"):
			playerPos = Vector2(allObjects[n].x, allObjects[n].y)
			break
	$Player.position = playerPos*16
	 
	print("done")
	#print((content.get_type()))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
	
#	pass

func readContents(content):
	var tiles = []
	for n in range(0, content.size()-1, 8):
		var ti = TileInfo.new()
		ti.type = content[n].split(" ")[1]
		ti.uid = content[n+1]
		ti.x = content[n+2]
		ti.y = content[n+3]
		ti.graphID = content[n+4]
		ti.coupleID = content[n+5]
		var tempString = content[n+6].split("-")	
		var actChildren = []
		for i in range(1, tempString.size()):
			actChildren.append(tempString[i])
		ti.actChildren = actChildren
		tiles.append(ti)
	return tiles
	
func GetObjects(arr):
	var newArr = []
	for n in range(0, arr.size()-1):
		if arr[n].type != "floor" && arr[n].type != "wall" && arr[n].type != "empty":
			newArr.append(arr[n])
	return newArr

func loadfile(filepath):
	var file = File.new()
	file.open(filepath, File.READ)
	var content = file.get_as_text()
	#print(content)
	file.close()
	return content
