extends Node

var opponent_id = -1

var myTurn = false
var pieceMovedThisTurn = false

func filterLeftClickAndTurnCheck(event):
	return (event is InputEventMouseButton && event.is_pressed() && event.get_button_index() == 1 && myTurn && not pieceMovedThisTurn)
