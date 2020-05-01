extends "res://Piece.gd"

enum ORIENTATION_TYPES {
	FRONT,
	RIGHT,
	BACK,
	LEFT
}

export(ORIENTATION_TYPES) var orientation

signal swap_clicked(self_node)

onready var swapClickBox = $SwapClickBox
onready var orientationNode = $Offset/Front

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
			$Offset/Left/BlueDefender.hide()
			$Offset/Front/BlueDefender.hide()
			$Offset/Right/BlueDefender.hide()
			$Offset/Back/BlueDefender.hide()
		COLOUR.BLUE:
			$Offset/Left/RedDefender.hide()
			$Offset/Front/RedDefender.hide()
			$Offset/Right/RedDefender.hide()
			$Offset/Back/RedDefender.hide()

func set_orientation(orientation):	
	#Hide and disable current orientation node
	orientationNode.hide()
	orientationNode.get_node("DefendBox/DefendBox").disabled = true
		
	match orientation:
		ORIENTATION_TYPES.FRONT:
			orientationNode = $Offset/Front
		ORIENTATION_TYPES.LEFT:
			orientationNode = $Offset/Left
		ORIENTATION_TYPES.RIGHT:
			orientationNode = $Offset/Right
		ORIENTATION_TYPES.BACK:
			orientationNode = $Offset/Back
	
	#Show and enable new orientation node
	orientationNode.show()
	orientationNode.get_node("DefendBox/DefendBox").disabled = false

func make_swappable(swappable):
	swapClickBox.enabled = swappable

func get_type():
	return "DEFENDER"
	
remotesync func rotate_right():
	orientation = orientation+1
	set_orientation(orientation)

remotesync func rotate_left():
	orientation = orientation-1
	set_orientation(orientation)

func _on_ClickBox_input_event(viewport, event, shape_idx):
	if (Helper.filterLeftClickAndTurnCheck(event)):
		toggle_selected()

func _on_DefendBox_area_entered(blast):
	blast.kill()

func _on_DeathBox_area_entered(blast):
	blast.kill()
	queue_free()

func _on_SwapClickBox_swap_clicked():
	emit_signal("swap_clicked", self)
