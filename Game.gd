extends Node2D

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")

func _player_connected(id):
	print("Player ", id, " connected to server!")
	
	#Game On!
	Helper.opponent_id = id
	var world = preload("res://Worlds/Ace.tscn").instance()
	get_tree().get_root().add_child(world)
	hide()

func _on_hostButton_pressed():
	print("Hosting Network")
	var host = NetworkedMultiplayerENet.new()
	var res = host.create_server(4545, 1)
	if res != OK:
		print("Error creating server")
		return
	
	$joinButton.hide()
	$hostButton.disabled = true
	get_tree().set_network_peer(host)


func _on_joinButton_pressed():
	var ip = $TextEdit.get_text()
	var host = NetworkedMultiplayerENet.new()
	
	print("Joining network at ", ip)
	
	host.create_client(ip, 4545)
	get_tree().set_network_peer(host)
	
	$hostButton.hide()
	$joinButton.disabled = true
