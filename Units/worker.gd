extends Unit;

var canBuild = true;

func _physics_process(delta):
	super._physics_process(delta);
	if owner_id == 1: $CharacterSprite.play("red_idle");
	else: $CharacterSprite.play("blue_idle");
