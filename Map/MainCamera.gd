extends Camera2D

@export var min = 0.5;
@export var max = 3;
#how much zoom is increased/decreased per scroll
@export var zoom_factor = .2;
#how long to reach the new camera zoom
@export var zoom_duration = 0.2;
var elapsed = 0;

#disable moving camera for testing
@export var disable_moving = false;

#target zoom level
var zoom_target = 10;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !disable_moving:
		var mouse = get_viewport().get_mouse_position();
		var width = get_viewport_rect().size.x;
		var height = get_viewport_rect().size.y;
		if mouse.x < 10 and position.x - width/2 >= limit_left: position += Vector2(-10, 0);
		elif mouse.x > width - 10 and position.x + width/2 <= limit_right: position += Vector2(10, 0);
		if mouse.y < 10 and position.y - height/2 >= limit_top: position += Vector2(0, -10);
		elif mouse.y > height - 10 and position.y + height/2 <= limit_bottom: position += Vector2(0, 10);

func _unhandled_input(event):
	if event.is_action_pressed("zoom_in"):
		set_zoom_level(zoom.x + zoom_factor);
	elif event.is_action_pressed("zoom_out"):
		set_zoom_level(zoom.x - zoom_factor);

func set_zoom_level(value) -> void:
	var tween = create_tween();
	zoom_target = clamp(value, min, max);
	tween.tween_property(self, "zoom", Vector2(zoom_target, zoom_target), zoom_duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE);
