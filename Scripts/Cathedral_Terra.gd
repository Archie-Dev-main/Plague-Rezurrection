extends Spatial


var zombie = preload("res://Scenes/Zombie.tscn")


func spawn_zombie():
	var zombo = zombie.instance()
	zombo.player = $Player
	$Navigation.add_child(zombo)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	pass


func _on_Timer_timeout():
	spawn_zombie()
