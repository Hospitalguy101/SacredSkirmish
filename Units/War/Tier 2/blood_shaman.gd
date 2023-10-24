extends Unit;

func _physics_process(delta):
	super._physics_process(delta);
	
	atk = 10 + 6*get_node("/root/Battlefield").ownedSites.size();
