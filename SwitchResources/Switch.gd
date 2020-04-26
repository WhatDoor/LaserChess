extends "res://Piece.gd"

onready var animationPlayer = $Offset/AnimationPlayer

var Blast = preload("res://Projectiles/Blast.tscn")

var DISTANCE_OFFSET = 4 #offsets from the centre of the switch piece so colliding projectiles dont get stuck when collding

func _ready():
	set_colour(team_colour)

func set_colour(team_colour):
	match team_colour:
		COLOUR.RED:
			$Offset/BlueSwitchSprite.hide()
		COLOUR.BLUE:
			$Offset/RedSwitchSprite.hide()

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

func _on_ClickBox_input_event(viewport, event, shape_idx):
	if (filterLeftClick(event)):
		toggle_selected()
