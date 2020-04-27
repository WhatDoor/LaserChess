extends Node2D

func _on_RightArrowClick_mouse_entered():
	$RightArrowSelected.show()


func _on_RightArrowClick_mouse_exited():
	$RightArrowSelected.hide()	
