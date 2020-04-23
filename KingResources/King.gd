extends Node2D

onready var blueKingSprite = $Offset/BlueKingSprite
onready var redKingSprite = $Offset/RedKingSprite

func _input(event):
	if event is InputEventMouseButton:
	   print("Mouse Click/Unclick at: ", event.position)
	
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.is_pressed():
		self.on_click()

func on_click():
	print("KING Click")

func _ready():
	pass

func _on_Area2D_area_entered(blast):
	blast.kill()
	queue_free()
