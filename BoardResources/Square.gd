extends Area2D

enum SQUARE_COLOUR {
	NORMAL,
	RED = 1,
	BLUE = 2
}

export(SQUARE_COLOUR) var colour = SQUARE_COLOUR.NORMAL

var selected = false

signal clicked(square)

func set_selected(selected):
	self.selected = selected
	
	if selected:
		$SelectedSquareSprite.show()
	else:
		$SelectedSquareSprite.hide()
		$HighlightedSelectedSquareSprite.hide()

func _on_Square_input_event(viewport, event, shape_idx):
	if (Helper.filterLeftClickAndTurnCheck(event)):
		emit_signal("clicked", self)

func _on_Square_mouse_entered():
	if selected:
		$HighlightedSelectedSquareSprite.show()


func _on_Square_mouse_exited():
	if selected:
		$HighlightedSelectedSquareSprite.hide()
