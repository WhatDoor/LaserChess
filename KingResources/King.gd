extends "res://Piece.gd"

onready var blueKingSprite = $Offset/BlueKingSprite
onready var redKingSprite = $Offset/RedKingSprite

func _ready():
	pass

func _on_ClickBox_input_event(viewport, event, shape_idx):
	if (filterLeftClick(event)):
		toggle_selected()

func _on_HitBox_area_entered(blast):
	blast.kill()
	queue_free()
