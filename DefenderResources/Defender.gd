extends Node2D

enum ORIENTATION_TYPES {
	FRONT,
	BACK,
	LEFT,
	RIGHT
}

export(ORIENTATION_TYPES) var orientation

var selected = false

signal selected(self_node)

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
		selected = !selected
		set_selector(selected)

func set_selector(selected):
	if (selected):
		$ClickBox/selectSprite.show()
		emit_signal("selected", self)
	else:
		$ClickBox/selectSprite.hide()

func filterLeftClick(event):
	return (event is InputEventMouseButton && event.pressed && event.get_button_index() == 1)

func _on_DefendBox_area_entered(blast):
	blast.kill()


func _on_DeathBox_area_entered(blast):
	blast.kill()
	queue_free()
