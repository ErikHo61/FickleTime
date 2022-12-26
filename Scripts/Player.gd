extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 300
#var screen_size
# Called when the node enters the scene tree for the first time.
func _ready():
#	screen_size = get_viewport_rect().size
	pass # Replace with function body.

func _physics_process(delta):
	var velocity =Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left")	:
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	move_and_slide(velocity)
	
	if(Input.is_action_just_released("ui_select")):
		Global.nextIndex()
		
	if(Input.is_action_just_released("time_travel")):
		Global.switchTime()
	#position.x = clamp(position.x, 0, screen_size.x)
	#position.y = clamp(position.y, 0, screen_size.y)
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

