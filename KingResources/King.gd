extends "res://Piece.gd"

onready var blueKingSprite = $Offset/BlueKingSprite
onready var redKingSprite = $Offset/RedKingSprite

func _ready():
	set_colour(team_colour)

func set_colour(team_colour):
	match team_colour:
		COLOUR.RED:
			$Offset/BlueKingSprite.hide()
		COLOUR.BLUE:
			$Offset/RedKingSprite.hide()

func get_type():
	return "KING"
	
func _on_ClickBox_input_event(viewport, event, shape_idx):
	if (Helper.filterLeftClickAndTurnCheck(event)):
		toggle_selected()

func _on_HitBox_area_entered(blast):
	blast.kill()
	queue_free()

