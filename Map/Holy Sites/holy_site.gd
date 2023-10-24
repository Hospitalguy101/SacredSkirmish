extends StaticBody2D

enum {
	PRODUCTION,
	FIGHTING,
	GOLD,
	SPEED,
	VISION,
	STRENGTH,
	CONCUSSION
}

var power;

var owner_id;
var id;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if multiplayer.get_unique_id() == owner_id: $PointLight2D.show();
	else: $PointLight2D.hide();
	
	match power:
		1:
			$Sprite2D.texture = load("res://Map/Holy Sites/fighting_site.png");
		2:
			$Sprite2D.texture = load("res://Map/Holy Sites/gold_site.png");
		3:
			$Sprite2D.texture = load("res://Map/Holy Sites/speed_site.png");
		4:
			$Sprite2D.texture = load("res://Map/Holy Sites/vision_site.png");
		5:
			$Sprite2D.texture = load("res://Map/Holy Sites/strength_site.png");
		6:
			$Sprite2D.texture = load("res://Map/Holy Sites/concussion_site.png");
