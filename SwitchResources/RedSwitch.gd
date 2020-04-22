extends Node2D

onready var animationPlayer = $Offset/AnimationPlayer

var Blast = preload("res://Projectiles/Blast.tscn")

var OFFSET = 5 #offsets from the centre of the switch piece so colliding projectiles dont get stuck when collding

func _input(event):
	# Mouse in viewport coordinates
	if event is InputEventMouseButton and event.is_pressed():
		var clickPos = to_local(event.position)
		if clickPos.x < 10.6 and clickPos.y < 10.6:
			animationPlayer.play("RotateRight")

func _on_BotHitBox_area_entered(blast):
	var angleOffset = 135
	var normalAngle = deg2rad($Offset.rotation_degrees + angleOffset)
	var normalVec = Vector2(cos(normalAngle), sin(normalAngle))
	var reflectionVec = blast.velocity.bounce(normalVec)
	
	blast.rotation_degrees = rad2deg(acos(reflectionVec.dot(Vector2(0,1))))
	blast.position = position + (reflectionVec * OFFSET)
	blast.fire(reflectionVec)

func _on_HitBoxTop_area_entered(blast):
	var angleOffset = 135 + 180
	var normalAngle = deg2rad($Offset.rotation_degrees + angleOffset)
	var normalVec = Vector2(cos(normalAngle), sin(normalAngle))
	var reflectionVec = blast.velocity.bounce(normalVec)
	
	blast.rotation_degrees = -rad2deg(acos(reflectionVec.dot(Vector2(0,1))))
	blast.position = position + (reflectionVec * OFFSET)
	blast.fire(reflectionVec)
