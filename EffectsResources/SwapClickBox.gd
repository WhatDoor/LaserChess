extends Area2D

signal swap_clicked

var enabled = false setget set_enabled

var mouse_over = false

func _ready():
	 # Enables the input detection:
	set_process_unhandled_input(true)
	
	self.enabled = false

func set_enabled(enabled):
	enabled = enabled
	
	if enabled:
		self.show()
		self.monitoring = true
		self.monitorable = true

	else:
		self.hide()
		self.monitoring = false
		self.monitorable = false

func _unhandled_input(event):
	if Helper.filterLeftClickAndTurnCheck(event) and mouse_over:
		get_tree().set_input_as_handled()
		emit_signal("swap_clicked")

func _on_SwapClickBox_mouse_entered():
	mouse_over = true


func _on_SwapClickBox_mouse_exited():
	mouse_over = false
