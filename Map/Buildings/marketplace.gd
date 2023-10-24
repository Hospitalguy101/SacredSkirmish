extends Building;

var moneyPerRound = 100;

func progress():
	super.progress();
	if !isBuilding:
		get_node("/root/Battlefield").money += moneyPerRound;
		

func upgrade():
	moneyPerRound += 100;
