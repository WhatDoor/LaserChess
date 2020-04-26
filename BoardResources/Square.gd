extends Area2D

enum SQUARE_COLOUR {
	NORMAL,
	RED = 1,
	BLUE = 2
}

export(SQUARE_COLOUR) var colour = SQUARE_COLOUR.NORMAL

signal clicked(square)

func set_selected(selected):
	if selected:
		$SelectedSquareSprite.show()
	else:
		$SelectedSquareSprite.hide()

func _on_Square_input_event(viewport, event, shape_idx):
	if (filterLeftClick(event)):
		emit_signal("clicked", self)

func filterLeftClick(event):
	return (event is InputEventMouseButton && event.pressed && event.get_button_index() == 1)
