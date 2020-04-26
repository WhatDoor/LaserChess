extends Node2D

enum COLOUR {
	RED = 1,
	BLUE = 2
}

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
		emit_signal("selected", self)
	else:
		$ClickBox/selectSprite.hide()
		emit_signal("deselected", self)

func set_selected(newSelected):
	if (newSelected):
		$ClickBox/selectSprite.show()
	else:
		$ClickBox/selectSprite.hide()
		
	selected = newSelected

func filterLeftClick(event):
	return (event is InputEventMouseButton && event.pressed && event.get_button_index() == 1)
