extends Node2D

enum {
	DOWN,
	RIGHT,
	LEFT,
	UP
}

enum team_colours {
	RED,
	BLUE
}

export(team_colours) var team_colour

export var fire_rate = 1
var can_fire = true

var state
var CENTRE_OFFSET = 12
var VERTICAL_OFFSET = Vector2(0,-6.7)

var Blast = preload("res://Projectiles/Blast.tscn")

onready var animationPlayer = $AnimationPlayer

func _ready():
	if team_colour == team_colours.RED:
		$BlueLaserSprite.hide()
		state = RIGHT
	elif team_colour == team_colours.BLUE:
		state = LEFT
		$RedLaserSprite.hide()

remotesync func animate():
	match state:
		DOWN:
			animationPlayer.play("SwingToRightFromDown")
			state = RIGHT
		RIGHT:
			animationPlayer.play("SwingToDownFromRight")
			state = DOWN
		LEFT:
			animationPlayer.play("SwingToUpFromLeft")
			state = UP
		UP:
			animationPlayer.play("SwingToLeftFromUp")
			state = LEFT
			
remotesync func fire_blast():
	#Instance, rotate and position blast
	var blast = Blast.instance()
	#blast.set_global_position($FirePoint.get_global_position())
	blast.position = get_position()
	#print("this position is ", get_global_position())
	#print("fire point position is ", $FirePoint.get_global_position())		
	print(name, " ", rotation_degrees)
	
	var rot
	if team_colour == team_colours.RED:
		rot = deg2rad(rotation_degrees - 90)
	elif team_colour == team_colours.BLUE:
		rot = deg2rad(rotation_degrees + 90)
	
	blast.fire(Vector2(-sin(rot), cos(rot)))
	
	get_parent().add_child(blast)
	
	can_fire = false
	yield(get_tree().create_timer(fire_rate), "timeout")
	can_fire = true

func _process(delta):
	if Input.is_action_pressed("End_Turn") and can_fire and is_network_master():
		rpc("fire_blast")

func _on_ClickBox_input_event(viewport, event, shape_idx):
	if (filterLeftClick(event) and is_network_master()):
		rpc("animate")

func filterLeftClick(event):
	return (event is InputEventMouseButton && event.pressed && event.get_button_index() == 1)
