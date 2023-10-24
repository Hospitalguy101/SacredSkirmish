extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var bf = get_node("/root/Battlefield");
	if bf.selectedUnit and bf.selectedUnit.tier == 0:
		show();
		if bf.selectedUnit.canBuild:
			for b in $GridContainer.get_children():
				b.disabled = false;
		else:
			for b in $GridContainer.get_children():
				b.disabled = true;
				
	else: hide();


func _on_market_button_pressed():
	var bf = get_node("/root/Battlefield");
	if bf.money >= 200:
		bf.build.rpc(0, bf.selectedUnit.position);
		bf.selectedUnit.canBuild = false;


func _on_barracks_button_pressed():
	var bf = get_node("/root/Battlefield");
	if bf.money >= 150:
		bf.build.rpc(1, bf.selectedUnit.position);
		bf.selectedUnit.canBuild = false;
