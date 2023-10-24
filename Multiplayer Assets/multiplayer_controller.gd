extends Control

@export var address = "127.0.0.1";
@export var port = 8910;
var peer;

var terrain_seed = Time.get_unix_time_from_system();

# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.peer_connected.connect(player_connected);
	multiplayer.peer_disconnected.connect(player_disconnected);
	multiplayer.connected_to_server.connect(connected_to_server);
	multiplayer.connection_failed.connect(connection_failed);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#called on server + client
func player_connected(id):
	GameManager.terrain_seed = terrain_seed;
	print("Player connected " + str(id));

#called on server + client
func player_disconnected(id):
	print("Player connected " + str(id));

#called only from clients
func connected_to_server():
	print("Connected to server");
	send_player_info.rpc_id(1, "test fac", multiplayer.get_unique_id(), 2);

#called only from clients
func connection_failed():
	print("Failed to connect");

@rpc("any_peer")
func send_player_info(faction, id, player):
	if player == 1:
		GameManager.player1 = {
			"faction": faction,
			"id": id
		}
	elif player == 2:
		GameManager.player2 = {
			"faction": faction,
			"id": id
		}
	
	#send new player info to all connected players
	if multiplayer.is_server():
		send_player_info.rpc(GameManager.player1.faction, GameManager.player1.id, 1);
		if GameManager.player2: send_player_info.rpc(GameManager.player2.faction, GameManager.player2.id, 2);

#allows this function to be called for all connected users
@rpc("any_peer", "call_local")
func start_game():
	seed(terrain_seed)
	GameManager.turnOrder.append(GameManager.player2.id);
	var scene = load("res://Map/battlefield.tscn").instantiate();
	get_tree().root.add_child(scene);
	
	#create towers
	var blueTower = load("res://Map/tower.tscn").instantiate();
	var redTower = load("res://Map/tower.tscn").instantiate();
	scene.add_child(blueTower);
	blueTower.position.x = randf_range(-300, 300);
	blueTower.position.y = randf_range(-500, -800)
	blueTower.isRed = false;
	scene.move_child(blueTower, 2)
	scene.add_child(redTower);
	redTower.position.x = randf_range(-300, 300);
	redTower.position.y = randf_range(500, 800);
	scene.move_child(redTower, 2);
	
	#create workers
	var blueWorker = load("res://Units/worker.tscn").instantiate();
	blueWorker.position.x = randf_range(blueTower.position.x - 100, blueTower.position.x + 100);
	blueWorker.position.y = randf_range(blueTower.position.y - 100, blueTower.position.y + 100);
	blueWorker.owner_id = GameManager.player2.id;
	blueWorker.get_node("MultiplayerSynchronizer").set_multiplayer_authority(GameManager.player2.id);
	scene.get_node("Units").add_child(blueWorker)
	
	#set starting camera positions
	if multiplayer.get_unique_id() == 1: scene.get_node("MainCamera").position = redTower.position;
	if multiplayer.get_unique_id() != 1: scene.get_node("MainCamera").position = blueTower.position;
	
	var redWorker = load("res://Units/worker.tscn").instantiate();
	redWorker.position.x = randf_range(redTower.position.x - 100, redTower.position.x + 100);
	redWorker.position.y = randf_range(redTower.position.y - 100, redTower.position.y + 100);
	redWorker.owner_id = GameManager.player1.id;
	redWorker.get_node("MultiplayerSynchronizer").set_multiplayer_authority(GameManager.player1.id);
	scene.get_node("Units").add_child(redWorker)
	
	#create holy sites
	var holy1 = load("res://Map/Holy Sites/holy_site.tscn").instantiate();
	scene.get_node("Holy Sites").add_child(holy1);
	holy1.position.x = randf_range(-700, 700);
	holy1.position.y = randf_range(-500, 500);
	holy1.id = 0;
	var holyP1 = randi_range(0, 6);
	holy1.power = holyP1;
	var holy2 = load("res://Map/Holy Sites/holy_site.tscn").instantiate();
	scene.get_node("Holy Sites").add_child(holy2);
	holy2.position.x = randf_range(-700, 700);
	holy2.position.y = randf_range(-500, 500);
	holy2.id = 1;
	var holyP2 = randi_range(0, 6);
	while holyP2 == holyP1:
		holyP2 = randi_range(0, 6);
	holy2.power = holyP2;
	var holy3 = load("res://Map/Holy Sites/holy_site.tscn").instantiate();
	scene.get_node("Holy Sites").add_child(holy3);
	holy3.position.x = randf_range(-700, 700);
	holy3.position.y = randf_range(-500, 500);
	holy3.id = 2;
	var holyP3 = randi_range(0, 6);
	while holyP3 == holyP1 or holyP3 == holyP2:
		holyP3 = randi_range(0, 6);
	holy3.power = holyP3;
	
	GameManager.holySites.append(holy1);
	GameManager.holySites.append(holy2);
	GameManager.holySites.append(holy3);
	
	hide();


func _on_host_button_down():
	peer = ENetMultiplayerPeer.new();
	var error = peer.create_server(port, 2);
	if error != OK:
		print("Cannot host: " + error);
		return;
		
	#compression algorithm, may not be best algorithm, but was recommended
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER);
	
	multiplayer.set_multiplayer_peer(peer);
	print("Waiting for players");
	send_player_info("test fac", multiplayer.get_unique_id(), 1);

func _on_join_button_down():
	peer = ENetMultiplayerPeer.new();
	peer.create_client(address, port);
	
	#compression algorithm, may not be best algorithm, but was recommended
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER);
	multiplayer.set_multiplayer_peer(peer);


func _on_start_button_down():
	start_game.rpc();
