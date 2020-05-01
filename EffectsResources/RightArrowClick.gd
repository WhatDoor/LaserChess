extends Area2D

signal clicked

var mouse_over = false

func _ready():
	 # Enables the input detection:
	set_process_unhandled_input(true)

func _unhandled_input(event):
	if Helper.filterLeftClickAndTurnCheck(event) and mouse_over:
		get_tree().set_input_as_handled()
		emit_signal("clicked")

func _on_RightArrowClick_mouse_entered():
	mouse_over = true

func _on_RightArrowClick_mouse_exited():
	mouse_over = false
