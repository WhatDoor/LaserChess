extends "res://Piece.gd"

enum ROTATION_TYPE {
	normal,
	rotated
}
export(ROTATION_TYPE) var rotation_type = ROTATION_TYPE.normal

onready var tween = $Tween
onready var offset = $Offset

var Blast = preload("res://Projectiles/Blast.tscn")

var DISTANCE_OFFSET = 10 #offsets from the centre of the switch piece so colliding projectiles dont get stuck when collding

func _ready():
	#initalize rotation arrows
	rotationArrows = $RotationArrows 
	rotationArrows.connect("clicked_left", self, "_on_RotationArrows_clicked_left")
	rotationArrows.connect("clicked_right", self, "_on_RotationArrows_clicked_right")
	
	set_colour(team_colour)
	
	#Set initial rotation
	if rotation_type == ROTATION_TYPE.rotated:
		offset.rotation_degrees = 90

func set_colour(team_colour):
	match team_colour:
		COLOUR.RED:
			$Offset/BlueSwitchSprite.hide()
		COLOUR.BLUE:
			$Offset/RedSwitchSprite.hide()

func get_type():
	return "SWITCH"

remotesync func rotate_right():
	tween.interpolate_property(offset, "rotation_degrees",
				offset.rotation_degrees, offset.rotation_degrees+90, 1,
				Tween.TRANS_QUAD, Tween.EASE_IN)
	tween.start()

remotesync func rotate_left():
	tween.interpolate_property(offset, "rotation_degrees",
				offset.rotation_degrees, offset.rotation_degrees-90, 1,
				Tween.TRANS_QUAD, Tween.EASE_IN)
	tween.start()

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
	if (Helper.filterLeftClickAndTurnCheck(event)):
		toggle_selected()
