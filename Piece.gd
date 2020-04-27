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
	#print(selected)
	selected = !selected
	
	if (selected):
		$ClickBox/selectSprite.show()
		if rotationArrows != null:
			rotationArrows.enabled = selected
		emit_signal("selected", self)
	else:
		$ClickBox/selectSprite.hide()
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
