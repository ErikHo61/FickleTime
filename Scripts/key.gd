extends Area2D

var id : int
var past_only = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.connect("in_past_changed", self, "_timeVisible")
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	past_only = bool(rng.randi_range(0, 1))
	if(past_only):
		visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _timeVisible(player_in_past):
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


func _on_Key_body_entered(_body):
	Global.key_found[int(id)] = true
	print("Player gained key# " + str(id))
	queue_free()
	pass # Replace with function body.
