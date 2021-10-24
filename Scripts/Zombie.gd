extends KinematicBody


var player = null


func set_player(node):
	player = node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	look_at(player.global_transform.origin, Vector3.UP)
	rotation.x = clamp(rotation.x, 0, 0)
	rotate_object_local(Vector3.UP, PI)
