extends RayCast2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = get_global_mouse_position();
	if is_colliding(): get_parent().hoveredUnit = get_collider().get_parent();
	else: get_parent().hoveredUnit = null;
	#print(get_collider());
