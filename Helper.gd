extends Node

var opponent_id = -1

#This Player's details
var myName = "Unnamed"
var myTurn = false
var isSpectator = true #everyone is a spectator by default unless specifically set by server
var myTeamColour = "SPECTATOR"

var pieceMovedThisTurn = false


func filterLeftClickAndTurnCheck(event):
	return (event is InputEventMouseButton && event.is_pressed() && event.get_button_index() == 1 && myTurn && not pieceMovedThisTurn && not isSpectator)
