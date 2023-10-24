extends CharacterBody2D

#empty unit class for other units to base themselves off
class_name Unit;

var unitName = "Test Unit";
@export var tier = 0;
var selected = false;
@export var maxMove = 100;
var currMove = maxMove;

#70 ~= melee
var attackRange = 70;

@export var atk = 1;
var atkMod = 1;
var towerDmgMod = 1;

@export var hp = 5;
var hpMod = 1;

#radius in cells that the unit can clear out visibility map
@export var vision = 5;
@export var trainingTime = 3;

@onready var targetLocation = position;

@export var debug_player = 0;

#id of owner player
var owner_id = 0;
#id of this specific unit
var id = -1;

var attackTarget;

#only false for each players base
var canMove = true;

#speed determines how fast the unit moves, not how far, no gameplay effect
const SPEED = 300;

func _ready():
	#create a unique id for this unit based on time of creation
	var t = Time.get_unix_time_from_system();
	if id == -1 and multiplayer.get_unique_id() == 1: setID.rpc(name, t);

func _physics_process(delta):
	if hp <= 0: die.rpc();
	
	if owner_id != multiplayer.get_unique_id():
		$PointLight2D.enabled = false;
		$SelectSprite.hide();
	#check to see if this unit belongs to the player and it is their turn
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id() and get_node("/root/Battlefield").currentPlayer == multiplayer.get_unique_id():
		if canMove:
			#will move unit towards target if it isn't already there
			if position.distance_to(targetLocation) > 10 and currMove > 0:
				velocity = position.direction_to(targetLocation) * SPEED;
				currMove -= 1;
				move_and_slide();
			elif currMove == 0:
				targetLocation = position;
			
			#if unit is moving to attack target and is in range, attack and stop
			#NOTE: distance will need to change when final sprites/attack ranges are in
			if attackTarget and position.distance_to(attackTarget.position) <= attackRange and currMove > 0:
				if attackTarget.is_in_group("Unit"): attack.rpc(attackTarget.id, atk*atkMod);
				
				#attacking a tower
				elif attackTarget.is_in_group("Tower"): 
					if attackTarget.isRed and owner_id != 1: attackTower.rpc(id);
					elif !attackTarget.isRed and owner_id == 1: attackTower.rpc(id);
					else: return;
					
				#capturing a holy site
				elif attackTarget.is_in_group("Holy Site"):
					captureSite.rpc(owner_id, attackTarget.id);
				targetLocation = position;
				attackTarget = null;
				currMove = 0;

@rpc("any_peer", "call_local")
func setID(name, id):
	for u in get_parent().get_children():
		if u.id == id:
			id += 0.01
	for u in get_parent().get_children():
		if u.name == name:
			u.id = id;

func select():
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		var bf = get_parent().get_parent();
		if (bf.selectedUnit): bf.selectedUnit.selected = false;
		bf.selectedUnit = self;
		if (bf.selectedBuilding): bf.selectedBuilding.selected = false;
		bf.selectedBuilding = null;
		$SelectSprite.show();
		$SelectSprite.play("select");
		selected = true;

func deselect():
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		var bf = get_parent().get_parent();
		$SelectSprite.play("deselect");
		bf.selectedUnit = null;
		selected = false;
		
@rpc("any_peer", "call_local")
func attack(target_id, dmg):
	for u in get_parent().get_children():
		if u.id == target_id:
			u.hp -= dmg;

@rpc("any_peer", "call_local")
func attackTower(attacker_id):
	var tower;
	var attacker;
	for u in get_parent().get_children():
		if u.id == attacker_id:
			attacker = u;
	for t in get_node("/root/Battlefield").get_children():
		if t.is_in_group("Tower"):
			if attacker.owner_id == 1 and !t.isRed:
				tower = t;
			elif attacker.owner_id != 1 and t.isRed:
				tower = t;

	tower.hp -= attacker.atk * attacker.atkMod * attacker.towerDmgMod;
	attacker.hp -= tower.atk;

@rpc("any_peer", "call_local")
func captureSite(capturerId, siteId):
	for s in get_node("/root/Battlefield/Holy Sites").get_children():
		if s.id == siteId:
			s.owner_id = capturerId;
			get_node("/root/Battlefield").ownedSites.append(s);

@rpc("any_peer", "call_local")
func die():
	queue_free();

func _on_hitbox_input_event(viewport, event, shape_idx):
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		if event.is_action_released("l_click"):
			#tell battlefield node that this input is handled already
			get_node("/root/Battlefield").inputHandled = true;
			
			#Will be called when mouse is released on this unit
			if !selected: select();
			else: deselect();

func _on_select_sprite_animation_finished():
	if $SelectSprite.animation == "deselect":
		$SelectSprite.visible = false;
