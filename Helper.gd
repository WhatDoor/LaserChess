extends Node

func filterLeftClick(event):
	return (event is InputEventMouseButton && event.is_pressed() && event.get_button_index() == 1)
