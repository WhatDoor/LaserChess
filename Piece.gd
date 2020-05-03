extends Node2D

enum COLOUR {
	RED = 1,
	BLUE = 2
}

onready var rotationArrows = null #REMEMBER TO INITIALIZE THIS IF YOU WANT ROTATION ARROWS

var selected = false
export(String) var board_coords
export(COLOUR) var team_colour

signal selected(self_node)
signal deselected(self_node)

signal piece_rotating_right(self_node)
signal piece_rotating_left(self_node)

signal mouse_over_piece(self_node)
signal mouse_off_piece(self_node)

func toggle_selected():
	if is_network_master():
		selected = !selected
		
		if (selected):
			#$ClickBox/selectSprite.show()
			if rotationArrows != null:
				rotationArrows.enabled = selected
			emit_signal("selected", self)
		else:
			#$ClickBox/selectSprite.hide()
			if rotationArrows != null:
				rotationArrows.enabled = selected
			emit_signal("deselected", self)

func set_selected(newSelected):
	if (newSelected):
		$ClickBox/selectSprite.show()
		if rotationArrows != null:
			rotationArrows.enabled = newSelected
	else:
		$ClickBox/selectSprite.hide()
		if rotationArrows != null:
			rotationArrows.enabled = newSelected
		
	selected = newSelected
	
remotesync func rotate_right():
	print(self.name, " rotating right - UNIMPLEMENTED ROTATION - Piece should override this function")

remotesync func rotate_left():
	print(self.name, " rotating left - UNIMPLEMENTED ROTATION - Piece should override this function")

func _on_RotationArrows_clicked_left():
	emit_signal("piece_rotating_right", self)

func _on_RotationArrows_clicked_right():
	emit_signal("piece_rotating_left", self)

func _on_Piece_Hovered():
	emit_signal("mouse_over_piece", self)

func _on_Piece_Off_Hovered():
	emit_signal("mouse_off_piece", self)
