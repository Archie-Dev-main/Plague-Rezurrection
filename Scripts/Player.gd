extends KinematicBody


const GRAVITY = -24.8
var vel = Vector3()
const MAX_SPEED = 20
const JUMP_SPEED = 18
const ACCEL = 4.5

var dir = Vector3()

const DEACCEL = 16
const MAX_SLOPE_ANGLE = 40

var camera
var rotation_helper

var MOUSE_SENSITIVITY = 0.05

var cur_melee_wep = 0
var cur_ranged_wep = 4

var cur_wep = cur_melee_wep

var damage_arr = [25, 50, 100, 50, 100]
var cur_dam = damage_arr[cur_wep]

onready var weapons = $Rotation_Helper/Camera/Weapon_Point.get_children()

var attack_ready = true

var health = 100


func display_current_weapon(wep):
	var temp = weapons[wep]
	temp.show()
	for i in weapons:
		if i != temp:
			i.hide()


func take_damage(dam):
	health -= dam


func do_damage(target):
	target.take_damage(cur_dam)



func _ready():
	camera = $Rotation_Helper/Camera
	rotation_helper = $Rotation_Helper

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	cur_wep = cur_melee_wep
	display_current_weapon(cur_wep)


func _physics_process(delta):
	process_input(delta)
	process_movement(delta)


func process_input(_delta):
	if health <= 0:
# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
	# ----------------------------------
	# Walking
	dir = Vector3()
	var cam_xform = camera.get_global_transform()
	
	var input_movement_vector = Vector2()
	
	if Input.is_action_pressed("movement_forward"):
		input_movement_vector.y += 1
	if Input.is_action_pressed("movement_backward"):
		input_movement_vector.y -= 1
	if Input.is_action_pressed("movement_left"):
		input_movement_vector.x -= 1
	if Input.is_action_pressed("movement_right"):
		input_movement_vector.x += 1
	
	input_movement_vector = input_movement_vector.normalized()
	
	# Basis vectors are already normalized.
	dir += -cam_xform.basis.z * input_movement_vector.y
	dir += cam_xform.basis.x * input_movement_vector.x
	# ----------------------------------
	
	# ----------------------------------
	# Jumping
	if is_on_floor():
		if Input.is_action_just_pressed("movement_jump"):
			vel.y = JUMP_SPEED
	# ----------------------------------
	
	# ----------------------------------
	# Switch Weapon
	if Input.is_action_just_pressed("combat_switch"):
		if cur_wep == cur_melee_wep:
			cur_wep = cur_ranged_wep
		else:
			cur_wep = cur_melee_wep
		cur_dam = damage_arr[cur_wep]
		
		display_current_weapon(cur_wep)
	# ----------------------------------
	
	# ----------------------------------
	# Attack
	if Input.is_action_just_pressed("combat_attack"):
		if cur_wep == 0:
			$AnimationPlayer.play("cane")
			if ($Rotation_Helper/Camera/Cane_Cast.is_colliding() && 
			$Rotation_Helper/Camera/Cane_Cast.get_collider().is_in_group("Zombies")
			&& attack_ready):
				do_damage($Rotation_Helper/Camera/Cane_Cast.get_collider())
				attack_ready = false
		elif cur_wep == 1:
			$AnimationPlayer.play("sword")
			if ($Rotation_Helper/Camera/Sword_Cast.is_colliding() && 
			$Rotation_Helper/Camera/Sword_Cast.get_collider().is_in_group("Zombies")
			&& attack_ready):
				do_damage($Rotation_Helper/Camera/Sword_Cast.get_collider())
				attack_ready = false
		elif cur_wep == 2:
			$AnimationPlayer.play("warhammer")
			if ($Rotation_Helper/Camera/Warhammer_Cast.is_colliding() && 
			$Rotation_Helper/Camera/Warhammer_Cast.get_collider().is_in_group("Zombies")
			&& attack_ready):
				do_damage($Rotation_Helper/Camera/Warhammer_Cast.get_collider())
				attack_ready = false
		elif cur_wep == 3:
			$AnimationPlayer.play("bow")
			if ($Rotation_Helper/Camera/Bow_Cast.is_colliding() && 
			$Rotation_Helper/Camera/Bow_Cast.get_collider().is_in_group("Zombies")
			&& attack_ready):
				do_damage($Rotation_Helper/Camera/Bow_Cast.get_collider())
				attack_ready = false
		elif cur_wep == 4:
			$AnimationPlayer.play("crossbow")
			if ($Rotation_Helper/Camera/Crossbow_Cast.is_colliding() && 
			$Rotation_Helper/Camera/Crossbow_Cast.get_collider().is_in_group("Zombies")
			&& attack_ready):
				do_damage($Rotation_Helper/Camera/Crossbow_Cast.get_collider())
				attack_ready = false
	# ----------------------------------
	
	# ----------------------------------
	# Capturing/Freeing the cursor
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		$CanvasLayer/HUD/Menu.popup()
		get_tree().paused = true
	# ----------------------------------


func process_movement(delta):
	dir.y = 0
	dir = dir.normalized()
	
	vel.y += delta * GRAVITY
	
	var hvel = vel
	hvel.y = 0
	
	var target = dir
	target *= MAX_SPEED
	
	var accel
	if dir.dot(hvel) > 0:
		accel = ACCEL
	else:
		accel = DEACCEL
	
	hvel = hvel.linear_interpolate(target, accel * delta)
	vel.x = hvel.x
	vel.z = hvel.z
	vel = move_and_slide(vel, Vector3(0, 1, 0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))


func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation_helper.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY * -1))
		self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))
		
		var camera_rot = rotation_helper.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		rotation_helper.rotation_degrees = camera_rot


func _on_AnimationPlayer_animation_finished(_anim_name):
	attack_ready = true
