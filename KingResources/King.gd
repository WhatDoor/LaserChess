extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var blueKingSprite = $Offset/BlueKingSprite
onready var redKingSprite = $Offset/RedKingSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_Area2D_area_entered(blast):
	blast.kill()
	queue_free()
