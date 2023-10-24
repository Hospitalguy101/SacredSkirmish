extends StaticBody2D

class_name Building;

@export var cost = 100;

@export var maxHP = 50.0;
var hp = 0;

@export var buildTime = 3;

var isBuilding = true;
var selected = false;

var owner_id;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isBuilding: 
		$Constructed.hide();
		$Constructed/CollisionShape2D.disabled = true;
		$Constructed/Hitbox/CollisionShape2D.disabled = true;
		$"Under Contruction".show();
	else:
		$Constructed.show();
		$Constructed/CollisionShape2D.disabled = false;
		$Constructed/Hitbox/CollisionShape2D.disabled = false;
		$"Under Contruction".hide();

#called when buliding is created
func startBuild(id):
	get_node("/root/Battlefield").money -= cost;
	owner_id = id;

#called each turn
func progress():
	if isBuilding:
		var hpStep = maxHP/buildTime;
		if hp != maxHP:
			hp += hpStep;
		else:
			finishBuild();

#called when building is finished
func finishBuild():
	isBuilding = false;

#called when building is upgraded
func upgrade():
	pass

func select():
	if owner_id == multiplayer.get_unique_id():
		var bf = get_node("/root/Battlefield");
		if (bf.selectedBuilding): bf.selectedBuilding.selected = false;
		bf.selectedBuilding = self;
		if (bf.selectedUnit): bf.selectedUnit.selected = false;
		bf.selectedUnit = null;
		$SelectSprite.show();
		$SelectSprite.play("select");
		selected = true;

func deselect():
	if owner_id == multiplayer.get_unique_id():
		var bf = get_node("/root/Battlefield");
		$SelectSprite.play("deselect");
		bf.selectedBuilding = null;
		selected = false;

func _on_hitbox_input_event(viewport, event, shape_idx):
	if owner_id == multiplayer.get_unique_id() and event.is_action_released("l_click"):
		get_node("/root/Battlefield").inputHandled = true;
		if selected: deselect();
		else: select();
