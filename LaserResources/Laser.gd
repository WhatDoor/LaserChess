extends Node2D

enum DIRECTIONS {
	DOWN,
	RIGHT,
	LEFT,
	UP
}

enum team_colours {
	RED,
	BLUE
}

export(DIRECTIONS) var state = DIRECTIONS.RIGHT
export(team_colours) var team_colour

export var fire_rate = 1
var can_fire = true

var CENTRE_OFFSET = 12
var VERTICAL_OFFSET = Vector2(0,-6.7)

var Blast = preload("res://Projectiles/Blast.tscn")

onready var animationPlayer = $AnimationPlayer

func _ready():
	if team_colour == team_colours.RED:
		$BlueLaserSprite.hide()
	elif team_colour == team_colours.BLUE:
		$RedLaserSprite.hide()

remotesync func animate():
	match state:
		DIRECTIONS.DOWN:
			animationPlayer.play("SwingToRightFromDown")
			state = DIRECTIONS.RIGHT
		DIRECTIONS.RIGHT:
			animationPlayer.play("SwingToDownFromRight")
			state = DIRECTIONS.DOWN
		DIRECTIONS.LEFT:
			animationPlayer.play("SwingToUpFromLeft")
			state = DIRECTIONS.UP
		DIRECTIONS.UP:
			animationPlayer.play("SwingToLeftFromUp")
			state = DIRECTIONS.LEFT
			
remotesync func fire_blast():
	if can_fire:
		#Instance, rotate and position blast
		var blast = Blast.instance()
		#blast.set_global_position($FirePoint.get_global_position())
		blast.position = get_position()
		#print("this position is ", get_global_position())
		#print("fire point position is ", $FirePoint.get_global_position())		
		#print(name, " ", rotation_degrees)
		
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

func _on_ClickBox_input_event(viewport, event, shape_idx):
	if (Helper.filterLeftClickAndTurnCheck(event) and is_network_master()):
		rpc("animate")
		Helper.pieceMovedThisTurn = true
