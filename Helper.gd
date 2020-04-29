extends Node

var opponent_id = -1

func filterLeftClick(event):
	return (event is InputEventMouseButton && event.is_pressed() && event.get_button_index() == 1)
