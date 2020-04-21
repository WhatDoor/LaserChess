extends Node2D

onready var animationPlayer = $AnimationPlayer

var Blast = preload("res://Projectiles/Blast.tscn")

func _input(event):
	# Mouse in viewport coordinates
	if event is InputEventMouseButton and event.is_pressed():
		var clickPos = to_local(event.position)
		if clickPos.x < 10.6 and clickPos.y < 10.6:
			animationPlayer.play("RotateRight")

func _on_BotHitBox_area_entered(blast):
	var angleOffset = 135
	var normalAngle = deg2rad(rotation_degrees + angleOffset)
	var normalVec = Vector2(cos(normalAngle), sin(normalAngle))
	var reflectionVec = blast.velocity.bounce(normalVec)
	
	
	blast.rotation_degrees = rad2deg(acos(reflectionVec.dot(Vector2(0,1))))
	blast.fire(reflectionVec)

func _on_HitBoxTop_area_entered(blast):
	var angleOffset = 135 + 180
	var normalAngle = deg2rad(rotation_degrees + angleOffset)
	var normalVec = Vector2(cos(normalAngle), sin(normalAngle))
	var reflectionVec = blast.velocity.bounce(normalVec)
	print(normalVec)
	
	blast.rotation_degrees = -rad2deg(acos(reflectionVec.dot(Vector2(0,1))))
	blast.fire(reflectionVec)
