extends TileMap

@export var width = 100;
@export var height = 100;

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in width:
		for y in width:
			set_cell(0, Vector2(x, y), 0, Vector2i(0, 0));


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for x in width:
		for y in height:
			for u in get_parent().get_node("Units").get_children():
				var vision_dist = u.vision;
				if (Vector2(x, y)*16 - Vector2(800, 800)).distance_to(u.position) < vision_dist*32 and u.owner_id == multiplayer.get_unique_id():
					erase_cell(0, Vector2(x, y))
			for t in get_parent().get_children():
				if t.is_in_group("Tower") and (Vector2(x, y)*16 - Vector2(800, 800)).distance_to(t.position) < 800/3:
					if !t.isRed and multiplayer.get_unique_id() != 1:
						erase_cell(0, Vector2(x, y));
					elif t.isRed and multiplayer.get_unique_id() == 1:
						erase_cell(0, Vector2(x, y));
