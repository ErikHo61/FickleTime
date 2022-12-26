extends StaticBody2D

var keyIDs = []
var is_open = false
var past_only = false

func _ready():
	pass
	

func _on_Area2D_body_entered(_body):
	#print(_body.name)
	if(past_only):
		if(Global.in_past):
			if(Global.checkKeys(keyIDs)):
				for keyID in keyIDs:
					print("Player used key: " + str(keyID))
				$BlockingCollisionNode.set_deferred("disabled", true)
				$AnimationPlayer.play("Open")
				is_open = true
		else:
			print("Cannot be opened at this time")
			
	else:
		if(Global.checkKeys(keyIDs)):
				for keyID in keyIDs:
					print("Player used key: " + str(keyID))
				$BlockingCollisionNode.set_deferred("disabled", true)
				$AnimationPlayer.play("Open")
				is_open = true
	pass # Replace with function body.



func _on_Area2D_body_exited(body):
#	if(is_open):
#		$BlockingCollisionNode.set_deferred("disabled", false)
#		$AnimationPlayer.play("Close")
	pass # Replace with function body.
