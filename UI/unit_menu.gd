extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_worker_button_pressed():
	if get_node("/root/Battlefield").money > 50:
		get_node("/root/Battlefield").selectedBuilding.trainUnit("res://Units/worker.tscn");
		get_node("/root/Battlefield").money -= 50;

func _on_tier_1_button_pressed():
	if get_node("/root/Battlefield").money > 300:
		get_node("/root/Battlefield").selectedBuilding.trainUnit("res://Units/War/Tier 1/marauder.tscn");
		get_node("/root/Battlefield").money -= 300;

func _on_tier_2_button_pressed():
	if get_node("/root/Battlefield").money > 800:
		get_node("/root/Battlefield").selectedBuilding.trainUnit("res://Units/War/Tier 2/blood_shaman.tscn");
		get_node("/root/Battlefield").money -= 800;

func _on_tier_3_button_pressed():
	if get_node("/root/Battlefield").money > 1500:
		get_node("/root/Battlefield").selectedBuilding.trainUnit("res://Units/War/Tier 3/siege_machine.tscn");
		get_node("/root/Battlefield").money -= 1500;
