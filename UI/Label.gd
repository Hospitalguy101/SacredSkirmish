extends Label

var money = 0;
# Called when the node enters the scene tree for the first time.
func _ready():
	money = get_node("/root/Battlefield").money


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	money = get_node("/root/Battlefield").money
	text = "Money " + str(money) + "$";
