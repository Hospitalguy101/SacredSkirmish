extends Building;

var trainingUnit;
var trainingTurnsLeft = 0;

@onready var unitMenu = get_node("/root/Battlefield/MainCamera/UILayer/Unit Menu");

func _process(delta):
	super._process(delta);
	
	if trainingUnit: 
		$Constructed/Label.show();
		$Constructed/Label.text = "Training: " + str(trainingTurnsLeft) + " turns";
	else: $Constructed/Label.hide();
	
func select():
	super.select();
	unitMenu.show();
	
func deselect():
	super.deselect();
	unitMenu.hide();

func trainUnit(path):
	for b in unitMenu.get_node("GridContainer").get_children():
		b.disabled = true;
	
	trainingUnit = load(path).instantiate();
	trainingTurnsLeft = trainingUnit.trainingTime;
	

func progress():
	super.progress();
	
	if trainingUnit:
		trainingTurnsLeft -= 1;
		print(trainingTurnsLeft)
		if trainingTurnsLeft == 0:
			get_node("/root/Battlefield/Units").add_child(trainingUnit);
			trainingUnit.owner_id = multiplayer.get_unique_id();
			trainingUnit.get_node("MultiplayerSynchronizer").set_multiplayer_authority(multiplayer.get_unique_id());
			trainingUnit.position = position;
			trainingUnit = false;
			
			for b in unitMenu.get_node("GridContainer").get_children():
				b.disabled = false;
