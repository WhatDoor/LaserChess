extends Node2D

func _ready():
	#position += Vector2(16*9,16*7)
	$Offset/Front.hide()


func _on_DefendBox_area_entered(blast):
	blast.kill()


func _on_DeathBox_area_entered(blast):
	blast.kill()
	queue_free()
