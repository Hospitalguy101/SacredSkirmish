extends Node2D

#unit that is currently selected
var selectedUnit;
var selectedBuilding;
#unit the mouse is hovering over
var hoveredUnit;
#tells the battlefield that an input has been handled by something else
var inputHandled = false;

var turn = 1;
#the player currenty taking their turn
var currentPlayer;

var money = 500;
var moneyPerRound = 100;

var ownedSites = [];

# Called when the node enters the scene tree for the first time.
func _ready():
	currentPlayer = GameManager.turnOrder[0];
	#THIS IS FOR TESTING ONLY - properly initializes units that exist on run
	for u in $Units.get_children():
		if u.debug_player == 0:
			u.owner_id = GameManager.player1.id;
			u.get_node("MultiplayerSynchronizer").set_multiplayer_authority(GameManager.player1.id);
		else:
			u.owner_id = GameManager.player2.id;
			u.get_node("MultiplayerSynchronizer").set_multiplayer_authority(GameManager.player2.id);
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(GameManager.turnOrder)

func _unhandled_input(event):
	#check if the input has been handled by a unit node already
	if !inputHandled:
		if event.is_action_released("l_click"):
			if selectedUnit: selectedUnit.deselect();
			selectedUnit = null;
			if selectedBuilding: selectedBuilding.deselect();
			selectedBuilding = null;
				
		if event.is_action_released("r_click") and currentPlayer == multiplayer.get_unique_id():
			if selectedUnit:
				#if mouse is hovinging over an enemy unit, attack it
				if hoveredUnit:
					if hoveredUnit.is_in_group("Unit") and hoveredUnit.owner_id != multiplayer.get_unique_id():
						selectedUnit.attackTarget = hoveredUnit;
					elif hoveredUnit.is_in_group("Tower") or hoveredUnit.is_in_group("Holy Site"):
						selectedUnit.attackTarget = hoveredUnit;
				selectedUnit.targetLocation = get_global_mouse_position();
	else: inputHandled = false;
	
#0 = marketplace, 1 = barracks
@rpc("any_peer", "call_local")
func build(building, pos):
	var buildNode;
	match building:
		0:
			buildNode = load("res://Map/Buildings/marketplace.tscn").instantiate();
		1:
			buildNode = load("res://Map/Buildings/barracks.tscn").instantiate();
			
	get_node("Buildings").add_child(buildNode);
	buildNode.position = pos;
	buildNode.startBuild(multiplayer.get_unique_id());

@rpc("any_peer", "call_local")
func next_turn():
	if currentPlayer == GameManager.turnOrder[0]:
		#switch current player to opponent
		currentPlayer = GameManager.turnOrder[1];
	else:
		turn += 1;
		currentPlayer = GameManager.turnOrder[0];
		for u in $Units.get_children():
			u.currMove = u.maxMove;
			if u.tier == 0: u.canBuild = true;
			
		#progress buildings
		for b in get_node("Buildings").get_children():
			b.progress();

func _on_end_turn_button_pressed():
	next_turn.rpc();
