extends Unit;

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

	tower.hp -= attacker.atk + 10;
	attacker.hp -= tower.atk;
	
func _physics_process(delta):
	super._physics_process(delta);
	
	if owner_id != multiplayer.get_unique_id():
		$Aura.hide();
	elif selected:
		$Aura.show();
		$Aura.texture = load("res://UI/aura_filled.png");
	else:
		$Aura.show();
		$Aura.texture = load("res://UI/aura.png");
	
	for u in get_parent().get_children():
		if u.position.distance_to(position) <= 192 and u.owner_id == owner_id and u != self:
			u.towerDmgMod = 1.25;
