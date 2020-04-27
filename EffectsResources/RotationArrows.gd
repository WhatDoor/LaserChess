extends Node2D

signal clicked_left
signal clicked_right

var enabled = false setget set_enabled

onready var leftArrowArea = $Left/LeftArrowClick
onready var rightArrowArea = $Right/RightArrowClick

func _ready():
	self.enabled = false

func _on_LeftArrowClick_clicked():
	emit_signal("clicked_left")


func _on_RightArrowClick_clicked():
	emit_signal("clicked_right")

func set_enabled(enabled):
	enabled = enabled
	
	if enabled:
		self.show()
		leftArrowArea.monitorable = true
		leftArrowArea.monitoring = true
		
		rightArrowArea.monitorable = true
		rightArrowArea.monitoring = true
	else:
		self.hide()
		leftArrowArea.monitorable = false
		leftArrowArea.monitoring = false
		
		rightArrowArea.monitorable = false
		rightArrowArea.monitoring = false
