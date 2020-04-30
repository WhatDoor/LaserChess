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
	print(self.name, " rotating right")

remotesync func rotate_left():
	print(self.name, " rotating left")

func _on_RotationArrows_clicked_left():
	rpc("rotate_right")

func _on_RotationArrows_clicked_right():
	rpc("rotate_left")
