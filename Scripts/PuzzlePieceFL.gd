extends Area2D

var id:int
var past_only = true
var picked_up = false
var activated = false
var piece_name = ""
var attributes = []

func _ready():
	Global.connect("in_past_changed", self, "_timeVisible")
	Global.connect("activate_next_pieceFL", self, "_activate")
	if(past_only):
		visible = false

	pass
	
func _activate(id):
	if(self.id == id):
		print(str(id) + " activated")
		activated = true
	
func _timeVisible(player_in_past):
	if(!picked_up && activated):
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


func _on_Area2D_body_entered(body):	
	if(!picked_up && activated):
		if(visible):
			print("Player gained piece " + str(id) + " " + piece_name)
			Global.puzzle_Inventory[id] = self
			self.visible = false
			if(Global.in_past):
				picked_up = true
	pass # Replace with function body.
