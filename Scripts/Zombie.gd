extends KinematicBody

var path = []
var path_node = 0

var speed = 1

var player = null

var health = 100
var attack_ready = true

onready var nav = get_parent()


func set_player(node):
	player = node


func take_damage(dam):
	health -= dam
	print("ow")


func do_damage():
	player.take_damage(25)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if health <= 0:
		queue_free()
	
	look_at(player.global_transform.origin, Vector3.UP)
	rotation.x = clamp(rotation.x, 0, 0)
	rotate_object_local(Vector3.UP, PI)
	
	if path_node < path.size():
		var direction = (path[path_node] - global_transform.origin)
		
		if direction.length() < 1:
			path_node += 1
		else:
# warning-ignore:return_value_discarded
			move_and_slide(direction.normalized() * speed, Vector3.UP)


func move_to(target_pos):
	path = nav.get_simple_path(global_transform.origin, target_pos)
	path_node = 0


func _on_Timer_timeout():
	move_to(player.global_transform.origin)


func _on_Area_body_entered(body):
	if body.name == "Player" and attack_ready:
		do_damage()
		attack_ready = false
		$Attack.start()


func _on_Attack_timeout():
	attack_ready = true
