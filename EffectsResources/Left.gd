extends Node2D

func _on_LeftArrowClick_mouse_entered():
	$LeftArrowSelected.show()


func _on_LeftArrowClick_mouse_exited():
	$LeftArrowSelected.hide()
