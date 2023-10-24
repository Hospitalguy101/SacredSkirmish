extends TileMap

@export var width = 100;
@export var height = 100;

var tempNoise = FastNoiseLite.new();
var percNoise = FastNoiseLite.new();

# Called when the node enters the scene tree for the first time.
func _ready():
	tile_set.tile_size = Vector2i(16, 16);
	#tempNoise.noise_type = FastNoiseLite.TYPE_PERLIN;
	tempNoise.seed = GameManager.terrain_seed;
	#percNoise.noise_type = FastNoiseLite.TYPE_PERLIN;
	percNoise.seed = GameManager.terrain_seed * GameManager.terrain_seed;
	
	for x in width:
		for y in width:
			var temp = tempNoise.get_noise_2d(x, y);
			var percip = percNoise.get_noise_2d(x, y);
			#print("temp: " + str(temp) + " percip: " + str(percip) + " x: " + str(x) + " y: " + str(y));
			if temp < -.4 and percip < 0:
				#snow
				set_cell(0, Vector2(x, y), 1, Vector2(3, 0));
			elif percip > .3 and temp < .13:
				#jungle
					set_cell(0, Vector2(x, y), 1, Vector2(2, 0));
			elif percip < -.12 and temp > .25:
				#desert
				set_cell(0, Vector2(x, y), 1, Vector2(0, 0));
			elif percip > .1:
				#forest
				set_cell(0, Vector2(x, y), 1, Vector2(4, 0));
			else:
				#plains
				set_cell(0, Vector2(x, y), 1, Vector2(1, 0));
				
