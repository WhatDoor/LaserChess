extends "res://Piece.gd"

enum ORIENTATION_TYPES {
	UP_LEFT = 0,
	UP_RIGHT = 1,
	DOWN_RIGHT = 2,
	DOWN_LEFT = 3
}

export(ORIENTATION_TYPES) var orientation

signal swap_clicked(self_node)

onready var swapClickBox = $SwapClickBox
onready var orientationNode = $Offset/UpLeft

var DISTANCE_OFFSET = 1 #offsets from the centre of the switch piece so colliding projectiles dont get stuck when collding
var normal_angle_degrees = -135

func _ready():
	#initalize rotation arrows
	rotationArrows = $RotationArrows 
	rotationArrows.connect("clicked_left", self, "_on_RotationArrows_clicked_left")
	rotationArrows.connect("clicked_right", self, "_on_RotationArrows_clicked_right")
	
	#Set colour and starting orientation
	set_colour(team_colour)
	set_orientation(orientation)

func set_colour(team_colour):
	match team_colour:
		COLOUR.RED:
			$Offset/UpLeft/BlueDeflector.hide()
			$Offset/UpRight/BlueDeflector.hide()
			$Offset/DownLeft/BlueDeflector.hide()
			$Offset/DownRight/BlueDeflector.hide()
		COLOUR.BLUE:
			$Offset/UpLeft/RedDeflector.hide()
			$Offset/UpRight/RedDeflector.hide()
			$Offset/DownLeft/RedDeflector.hide()
			$Offset/DownRight/RedDeflector.hide()

func set_orientation(orientation):	
	#Hide and disable current orientation node
	orientationNode.hide()
	orientationNode.get_node("ReflectBox/ReflectBox").disabled = true
		
	match orientation:
		ORIENTATION_TYPES.UP_LEFT:
			orientationNode = $Offset/UpLeft
			normal_angle_degrees = -135
		ORIENTATION_TYPES.UP_RIGHT:
			orientationNode = $Offset/UpRight
			normal_angle_degrees = -45
		ORIENTATION_TYPES.DOWN_LEFT:
			orientationNode = $Offset/DownLeft
			normal_angle_degrees = 135
		ORIENTATION_TYPES.DOWN_RIGHT:
			orientationNode = $Offset/DownRight
			normal_angle_degrees = 45
	
	#Show and enable new orientation node
	orientationNode.show()
	orientationNode.get_node("ReflectBox/ReflectBox").disabled = false

func make_swappable(swappable):
	swapClickBox.enabled = swappable

func get_type():
	return "DEFLECTOR"

remotesync func rotate_right():
	orientation = orientation+1
	if orientation == 4:
		orientation = 0
	set_orientation(orientation)

remotesync func rotate_left():
	orientation = orientation-1
	if orientation == -1:
		orientation = 3
	set_orientation(orientation)

func _on_ReflectBox_area_entered(blast):
	var reflectionVec = get_reflectionVec(blast)

	blast.position = position + (reflectionVec * DISTANCE_OFFSET)
	blast.fire(reflectionVec)
	
func get_reflectionVec(blast):
	var normalAngle = deg2rad(normal_angle_degrees)
	var normalVec = Vector2(cos(normalAngle), sin(normalAngle))
	return blast.velocity.bounce(normalVec)
	
func _on_SwapClickBox_swap_clicked():
	emit_signal("swap_clicked", self)

func _on_DeathBox_area_entered(blast):
	blast.kill()
	queue_free()

func _on_ClickBox_input_event(viewport, event, shape_idx):
	if (Helper.filterLeftClickAndTurnCheck(event)):
		toggle_selected()
