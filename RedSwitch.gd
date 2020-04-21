extends Area2D

var Blast = preload("res://Blast.tscn")

func _on_RedSwitch_area_entered(area):
	print("Hit the red switch")
	var blast = Blast.instance()
	blast.position = $FirePoint.get_position_in_parent()
	blast.rotation_degrees = $FirePoint.rotation_degrees
	print($FirePoint.get_global_position())
	var rot = deg2rad($FirePoint.rotation_degrees)
	
	blast.fire(Vector2(-sin(rot), cos(rot)))
	call_deferred("addToScene", blast)
	
func addToScene(blast):	
	#get_parent().add_child(blast)
	get_tree().get_root().add_child(blast)
