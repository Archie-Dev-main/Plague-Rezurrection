extends Spatial


var zombie = preload("res://Scenes/Zombie.tscn")


func spawn_zombie():
	var zombie_instance = zombie.instance()
	zombie_instance.player = $Player
	zombie_instance.scale = Vector3(1.75,1.75,1.75)
	zombie_instance.translation = $Navigation/Spawn_Point.translation
	$Navigation.add_child(zombie_instance)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Timer_timeout():
	spawn_zombie()
