extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var bf = get_node("/root/Battlefield");
	if bf.selectedUnit and bf.selectedUnit.is_in_group("Unit"):
		$UnitInfo/AtkLabel.text = "Attack: " + str(bf.selectedUnit.atk);
		$UnitInfo/HealthLabel.text = "Health: " + str(bf.selectedUnit.hp);
		$UnitInfo/Name.text = str(bf.selectedUnit.id);
		$UnitInfo/MoveBar.max_value = bf.selectedUnit.maxMove;
		$UnitInfo/MoveBar.value = bf.selectedUnit.currMove;
		visible = true;
	else: visible = false;
