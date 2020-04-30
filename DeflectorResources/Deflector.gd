extends "res://Piece.gd"

signal swap_clicked(self_node)

onready var swapClickBox = $SwapClickBox

func _ready():
	#initalize rotation arrows
	rotationArrows = $RotationArrows 
	rotationArrows.connect("clicked_left", self, "_on_RotationArrows_clicked_left")
	rotationArrows.connect("clicked_right", self, "_on_RotationArrows_clicked_right")
	
	#Set colour
	set_colour(team_colour)

func set_colour(team_colour):
	match team_colour:
		COLOUR.RED:
			$Offset/UpLeft/BlueDeflector.hide()
			$Offset/UpRight/BlueDeflector.hide()
		COLOUR.BLUE:
			$Offset/UpLeft/RedDeflector.hide()
			$Offset/UpRight/RedDeflector.hide()

func make_swappable(swappable):
	swapClickBox.enabled = swappable

func get_type():
	return "DEFLECTOR"
	
func _on_SwapClickBox_swap_clicked():
	emit_signal("swap_clicked", self)

func _on_DeathBox_area_entered(blast):
	blast.kill()
	queue_free()

func _on_ClickBox_input_event(viewport, event, shape_idx):
	if (Helper.filterLeftClick(event)):
		toggle_selected()
