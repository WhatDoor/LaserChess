extends Node2D

onready var blueKingSprite = $Offset/BlueKingSprite
onready var redKingSprite = $Offset/RedKingSprite

var selected = false

signal selected(self_node)

func on_click():
	print("KING Click")

func _ready():
	pass

func _on_HitBox_area_entered(blast):
	blast.kill()
	queue_free()


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
