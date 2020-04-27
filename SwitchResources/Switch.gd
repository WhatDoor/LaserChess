extends "res://Piece.gd"

onready var animationPlayer = $Offset/AnimationPlayer

var Blast = preload("res://Projectiles/Blast.tscn")

var DISTANCE_OFFSET = 10 #offsets from the centre of the switch piece so colliding projectiles dont get stuck when collding

func _ready():
	rotationArrows = $RotationArrows #initalize rotation arrows
	set_colour(team_colour)

func set_colour(team_colour):
	match team_colour:
		COLOUR.RED:
			$Offset/BlueSwitchSprite.hide()
		COLOUR.BLUE:
			$Offset/RedSwitchSprite.hide()

func get_type():
	return "SWITCH"

func _on_BotHitBox_area_entered(blast):
	var normalAngleOffset = 135
	var reflectionVec = get_reflectionVec(blast, normalAngleOffset)

	blast.position = position + (reflectionVec * DISTANCE_OFFSET)
	blast.fire(reflectionVec)

func _on_HitBoxTop_area_entered(blast):
	var normalAngleOffset = 135 + 180
	var reflectionVec = get_reflectionVec(blast, normalAngleOffset)
	
	blast.position = position + (reflectionVec * DISTANCE_OFFSET)
	blast.fire(reflectionVec)
	
func get_reflectionVec(blast, normalAngleOffset):
	var normalAngle = deg2rad($Offset.rotation_degrees + normalAngleOffset)
	var normalVec = Vector2(cos(normalAngle), sin(normalAngle))
	return blast.velocity.bounce(normalVec)

func _on_ClickBox_input_event(viewport, event, shape_idx):
	if (Helper.filterLeftClick(event)):
		toggle_selected()

func _on_RotationArrows_clicked_left():
	animationPlayer.play("FullRotation")
	print(self.name, " rotating right. New Angle is ", $Offset.rotation_degrees)

func _on_RotationArrows_clicked_right():
	$Offset.rotation_degrees -= 90
	print(self.name, " rotating left. New Angle is ", $Offset.rotation_degrees)
