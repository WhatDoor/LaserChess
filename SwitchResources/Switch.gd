extends "res://Piece.gd"

enum ROTATION_TYPE {
	normal,
	rotated
}
export(ROTATION_TYPE) var rotation_type = ROTATION_TYPE.normal

onready var orientationNode = $Offset/Normal

onready var tween = $Tween
onready var offset = $Offset

var Blast = preload("res://Projectiles/Blast.tscn")

var reflection_angle = 0
var DISTANCE_OFFSET = 3 #offsets from the centre of the switch piece so colliding projectiles dont get stuck when collding

func _ready():
	#initalize rotation arrows
	rotationArrows = $RotationArrows 
	rotationArrows.connect("clicked_left", self, "_on_RotationArrows_clicked_left")
	rotationArrows.connect("clicked_right", self, "_on_RotationArrows_clicked_right")
	
	set_colour(team_colour)
	set_orientation(rotation_type)

func set_colour(team_colour):
	match team_colour:
		COLOUR.RED:
			$Offset/Normal/BlueSwitchSprite.hide()
			$Offset/Normal/BlueSwitchSprite.hide()
		COLOUR.BLUE:
			$Offset/Rotated/RedSwitchSprite.hide()
			$Offset/Rotated/RedSwitchSprite.hide()

func get_type():
	return "SWITCH"

remotesync func rotate_right():
	rotation_type = rotation_type + 1
	if rotation_type == 4:
		rotation_type = 0
	set_orientation(rotation_type)
	
remotesync func rotate_left():
	rotation_type = rotation_type - 1
	if rotation_type == 4:
		rotation_type = 0
	set_orientation(rotation_type)
	
func set_orientation(orientation):	
	#Hide and disable current orientation node
	orientationNode.hide()
	
	match orientation:
		ROTATION_TYPE.normal:
			orientationNode = $Offset/Normal
			$Offset/Hitboxes.rotation_degrees = 0
			reflection_angle = 0
		ROTATION_TYPE.rotated:
			orientationNode = $Offset/Rotated
			$Offset/Hitboxes.rotation_degrees = 90
			reflection_angle = 90
	
	#Show and enable new orientation node
	orientationNode.show()

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
	var normalAngle = deg2rad(reflection_angle + normalAngleOffset)
	var normalVec = Vector2(cos(normalAngle), sin(normalAngle))
	return blast.velocity.bounce(normalVec)

func _on_ClickBox_input_event(viewport, event, shape_idx):
	if (Helper.filterLeftClickAndTurnCheck(event)):
		toggle_selected()
