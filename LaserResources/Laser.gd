extends Node2D

enum {
	DOWN,
	RIGHT
}

var state = RIGHT

export var fire_rate = 0.5
var can_fire = true

var CENTRE_OFFSET = 12
var VERTICAL_OFFSET = Vector2(0,-6.7)

var Blast = preload("res://Projectiles/Blast.tscn")

onready var animationPlayer = $AnimationPlayer

func animate():
	match state:
		DOWN:
			animationPlayer.play("SwingRight")
			state = RIGHT
		RIGHT:
			animationPlayer.play("SwingDown")
			state = DOWN

func _process(delta):
	if Input.is_action_pressed("End_Turn") and can_fire:
		#Instance, rotate and position blast
		var blast = Blast.instance()
		blast.position = get_position()
		blast.rotation_degrees = rotation_degrees - 90
		
		var rot = deg2rad(rotation_degrees - 90)
		blast.fire(Vector2(-sin(rot), cos(rot)))
		
		#Offset position
		#blast.position += blast.velocity * CENTRE_OFFSET
		#blast.position += VERTICAL_OFFSET
		
	
		get_parent().add_child(blast)
		
		can_fire = false
		yield(get_tree().create_timer(fire_rate), "timeout")
		can_fire = true
