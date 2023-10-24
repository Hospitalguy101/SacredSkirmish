extends StaticBody2D

@export var hp = 500;
@export var atk = 30;

@export var isRed = true;

# Called when the node enters the scene tree for the first time.
func _ready():
	$HealthBar.max_value = hp;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !isRed:
		$Sprite2D.texture = load("res://Map/blue_tower.png");
		if multiplayer.get_unique_id() == 1:
			$PointLight2D.enabled = false;
	else:
		if multiplayer.get_unique_id() != 1:
			$PointLight2D.enabled = false;
	$HealthBar.value = hp;
