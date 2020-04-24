extends Node2D

onready var animationPlayer = $Offset/AnimationPlayer

var Blast = preload("res://Projectiles/Blast.tscn")

var DISTANCE_OFFSET = 7 #offsets from the centre of the switch piece so colliding projectiles dont get stuck when collding

func _input(event):
	# Mouse in viewport coordinates
	if event is InputEventMouseButton and event.is_pressed():
		var clickPos = to_local(event.position)
		if clickPos.x < 10.6 and clickPos.y < 10.6:
			animationPlayer.play("RotateRight")

func _on_BotHitBox_area_entered(blast):
	var angleOffset = 135
	var reflectionVec = get_reflectionVec(blast, angleOffset)
	
	blast.rotation_degrees = get_reflection_rotation(reflectionVec)
	blast.position = position + (reflectionVec * DISTANCE_OFFSET)
	blast.fire(reflectionVec)

func _on_HitBoxTop_area_entered(blast):
	var angleOffset = 135 + 180
	var reflectionVec = get_reflectionVec(blast, angleOffset)
	
	blast.rotation_degrees = -get_reflection_rotation(reflectionVec) #This needs to be negative because it reflects on the other side
	blast.position = position + (reflectionVec * DISTANCE_OFFSET)
	blast.fire(reflectionVec)
	
func get_reflectionVec(blast, angleOffset):
	var normalAngle = deg2rad($Offset.rotation_degrees + angleOffset)
	var normalVec = Vector2(cos(normalAngle), sin(normalAngle))
	return blast.velocity.bounce(normalVec)

func get_reflection_rotation(reflectionVec):	
	return rad2deg(acos(reflectionVec.dot(Vector2(0,1))))
