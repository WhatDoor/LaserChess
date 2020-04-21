extends Node2D

enum {
	DOWN,
	RIGHT
}

export var fire_rate = 0.2

var state = RIGHT
var can_fire = true

var Blast = preload("res://Blast.tscn")

onready var animationPlayer = $AnimationPlayer



func _input(event):
	# Mouse in viewport coordinates
	if event is InputEventMouseButton and event.is_pressed():
		var clickPos = to_local(event.position)
		if clickPos.x < 10.6 and clickPos.y < 10.6:
			animate()

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
		var blast = Blast.instance()
		blast.position = get_position()
		blast.rotation_degrees = rotation_degrees
		var rot = deg2rad(rotation_degrees)
		
		blast.fire(Vector2(-sin(rot), cos(rot)))
		get_parent().add_child(blast)
		
		can_fire = false
		yield(get_tree().create_timer(fire_rate), "timeout")
		can_fire = true
