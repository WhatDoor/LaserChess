extends Node2D

var hostLobby = null

var pinged_server_with_info = false

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	$NotificationText.hide()
	
	hostLobby = preload("res://HostLobby.tscn").instance()
	get_tree().get_root().call_deferred("add_child",hostLobby)
	hostLobby.hide()

func _player_connected(id):
	if not get_tree().is_network_server() and not pinged_server_with_info:
		print("Connected to server")
		get_tree().get_root().get_node("HostLobby").rpc_id(1, "player_connected", get_tree().get_network_unique_id() , Helper.myName)
		$NotificationText.set_text("Joined - Waiting for Host")
		$NotificationText.show()
		
		pinged_server_with_info = true
		
remote func set_as_player(id, team_colour):
	Helper.opponent_id = id
	Helper.myTeamColour = team_colour
	Helper.isSpectator = false

func _on_hostButton_pressed():
	Helper.myName = $nameTextEdit.get_text()
	
	print("Hosting Network")
	var host = NetworkedMultiplayerENet.new()
	var res = host.create_server(4545, 20)
	if res != OK:
		print("Error creating server")
		return
	
	$joinButton.hide()
	$hostButton.disabled = true
	get_tree().set_network_peer(host)
	
	hostLobby.show()
	hide()

func _on_joinButton_pressed():
	Helper.myName = $nameTextEdit.get_text()
	
	var ip = $ipTextEdit.get_text()
	var host = NetworkedMultiplayerENet.new()
	
	print("Joining network at ", ip)
	
	host.create_client(ip, 4545)
	get_tree().set_network_peer(host)
	
	$hostButton.hide()
	$joinButton.disabled = true
	
#Game On!
remote func startgame():
	var world = preload("res://Worlds/Ace.tscn").instance()
	get_tree().get_root().add_child(world)
	hide()
