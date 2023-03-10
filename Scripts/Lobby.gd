extends Node

const PORT = 35516



func _on_host_pressed():
	var peer = ENetMultiplayerPeer.new()
	
	peer.create_server(PORT)
	
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("No anduvo hostear :c")
		return
		
	multiplayer.multiplayer_peer = peer
	
	
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(del_player)
	
	for id in multiplayer.get_peers():
		add_player(id)
		print("Spawneando un conectado ")
	
	if not OS.has_feature("dedicated_server"):
		print("spawneado el host")
		add_player(1)
	
	
	start_game()


func _on_join_pressed():
	var dir = "192.168.0.105"
	
	var peer = ENetMultiplayerPeer.new()
	
	peer.create_client(dir, PORT)
	
	print("peer da ", peer)
	
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("No nos unimos :c")
		return
		
	multiplayer.multiplayer_peer = peer
	start_game()
	
func start_game():
	$Mundo/Pelota.gravity_scale = 1
	
	$Control.hide()
	

func _exit_tree():
	
	if not multiplayer.is_server():
		return
	multiplayer.peer_connected.disconnect(add_player)
	multiplayer.peer_disconnected.disconnect(del_player)
	
func add_player(id: int):
	var character = preload("res://Player/Player.tscn").instantiate()
	# Set player id.
	# Randomize character position.
	
	
	
	var pos := Vector2.from_angle(randf() * 2 * PI)
	character.position = Vector3(pos.x * 5 * randf(), 0, pos.y * 5 * randf())
	character.name = str(id)
	$Mundo/Players.add_child(character, true)
	
func del_player(id: int):
	if not 	$Mundo/Players.has_node(str(id)):
		return
	$Mundo/Players.get_node(str(id)).queue_free()
