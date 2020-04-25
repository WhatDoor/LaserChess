extends "res://Piece.gd"

enum ORIENTATION_TYPES {
	FRONT,
	BACK,
	LEFT,
	RIGHT
}

export(ORIENTATION_TYPES) var orientation

func _ready():
	$Offset/Front.hide() #Hide the starting orientation which is used for game dev
	set_orientation(orientation)

func set_orientation(orientation):	
	var orientationNode
		
	match orientation:
		ORIENTATION_TYPES.FRONT:
			orientationNode = $Offset/Front
		ORIENTATION_TYPES.LEFT:
			orientationNode = $Offset/Left
		ORIENTATION_TYPES.RIGHT:
			pass
		ORIENTATION_TYPES.BACK:
			pass
	
	orientationNode.show()
	orientationNode.get_node("DefendBox/DefendBox").disabled = false

func _on_ClickBox_input_event(viewport, event, shape_idx):
	if (filterLeftClick(event)):
		toggle_selected()

func _on_DefendBox_area_entered(blast):
	blast.kill()

func _on_DeathBox_area_entered(blast):
	blast.kill()
	queue_free()
