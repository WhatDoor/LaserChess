extends "res://Piece.gd"

enum ORIENTATION_TYPES {
	FRONT,
	BACK,
	LEFT,
	RIGHT
}

export(ORIENTATION_TYPES) var orientation

signal swap_clicked(self_node)

onready var swapClickBox = $SwapClickBox

func _ready():
	rotationArrows = $RotationArrows #initalize rotation arrows
	
	$Offset/Front.hide() #Hide the starting orientation which is used for game dev
	set_colour(team_colour)
	set_orientation(orientation)

func set_colour(team_colour):
	match team_colour:
		COLOUR.RED:
			$Offset/Left/LeftBlueDefender.hide()
			$Offset/Front/FrontBlueDefender.hide()
		COLOUR.BLUE:
			$Offset/Left/LeftRedDefender.hide()
			$Offset/Front/FrontRedDefender.hide()

func set_orientation(orientation):	
	var orientationNode
		
	match orientation:
		ORIENTATION_TYPES.FRONT:
			orientationNode = $Offset/Front
		ORIENTATION_TYPES.LEFT:
			orientationNode = $Offset/Left
		ORIENTATION_TYPES.RIGHT:
			pass
		ORIENTATION_TYPES.BACK:
			pass
	
	orientationNode.show()
	orientationNode.get_node("DefendBox/DefendBox").disabled = false

func make_swappable(swappable):
	swapClickBox.enabled = swappable

func get_type():
	return "DEFENDER"

func _on_ClickBox_input_event(viewport, event, shape_idx):
	if (Helper.filterLeftClick(event) and is_network_master()):
		rpc("toggle_selected")

func _on_DefendBox_area_entered(blast):
	blast.kill()

func _on_DeathBox_area_entered(blast):
	blast.kill()
	queue_free()

func _on_RotationArrows_clicked_left():
	print(self.name, " rotating right")
	$Offset.rotation_degrees += 90

func _on_RotationArrows_clicked_right():
	print(self.name, " rotating left")
	$Offset.rotation_degrees -= 90

func _on_SwapClickBox_swap_clicked():
	emit_signal("swap_clicked", self)
