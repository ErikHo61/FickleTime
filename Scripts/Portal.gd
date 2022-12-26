extends Area2D

var in_portal = false

func _ready():
	#Global.connect("in_past_changed", self, "_testing")
	pass

func _process(delta):
	if(in_portal):
		if(Input.is_action_just_released("ui_accept")):
			Global.switchTime()			
				
	pass

	
func _on_Node2D_body_entered(body):
	in_portal = true
	pass # Replace with function body.


func _on_Node2D_body_exited(body):
	in_portal = false
	pass # Replace with function body.
