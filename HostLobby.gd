extends Node2D

onready var lobby = get_tree().get_root().get_node("Lobby")

var list_of_players = []

func _ready():
	var profile = {"name": "Host", "id":1}
	list_of_players.append(profile)
	update_playerOutput()

remote func player_connected(id, playerName):
	print("Player " + playerName + " - " + str(id) + " connected!")
	
	var profile = {"name": playerName, "id":id}
	list_of_players.append(profile)
	update_playerOutput()
	
func update_playerOutput():
	var output_text = ""
	
	for player in list_of_players:
		output_text = output_text + player.name + " - " + str(player.id) + "\n"
	
	$playerOutput.set_text(output_text)

func _on_startGameButton_pressed():
	var redPlayerId = int($redPlayerID.get_text())
	var bluePlayerId = int($bluePlayerID.get_text())
	
	if found(redPlayerId) and found(bluePlayerId):
		set_as_player(redPlayerId, bluePlayerId, "RED")
		set_as_player(bluePlayerId, redPlayerId, "BLUE")
		
		print("Starting Game!")
		lobby.rpc("startgame") #Start game for everyone else
		startgame() #Start game for server
		get_tree().set_refuse_new_network_connections(true)
	else:
		print("Start Game Failed - player IDs not recognised")

func set_as_player(targetPlayerID, targetOpponentID, targetColour):
	if targetPlayerID != 1:
		lobby.rpc_id(targetPlayerID, "set_as_player", targetOpponentID, targetColour)
	else:
		Helper.opponent_id = targetOpponentID
		Helper.myTeamColour = targetColour
		Helper.isSpectator = false
		
func found(playerID):
	for player in list_of_players:
		if player.id == playerID:
			return true
	
	return false

func startgame():
	var world = preload("res://Worlds/Ace.tscn").instance()
	get_tree().get_root().add_child(world)
	hide()
