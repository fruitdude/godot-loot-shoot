extends KinematicBody


var mouse_sensitivity = 1
var cam_accel = 60
var speed = 4
var speed_multiplier = 1
var acceleration = 10
var gravity = 9.8
var jump_height = 4
var stick_amount = 10

var direction = Vector3()
var gravity_vec = Vector3()
var movement = Vector3()
var velocity = Vector3()

var on_ground = false
var can_jump = false

var jump_direction = Vector3()


onready var head = $Head
onready var camera = $Head/Camera
onready var jump_timer = $JumpTimer


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * mouse_sensitivity / 10
		head.rotation_degrees.x = clamp(head.rotation_degrees.x - event.relative.y * mouse_sensitivity / 10, -70, 80)
	
	direction = Vector3()
	_walk()
	
	
func _walk():
	direction.z = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	direction = direction.normalized()
	if direction.z < 0:
		direction.z = direction.z * speed_multiplier
	direction = direction.rotated(Vector3.UP, rotation.y)


func _process(delta):
	#camera physics interpolation to reduce physics jitter on high refresh-rate monitors
	if Engine.get_frames_per_second() > Engine.iterations_per_second:
		camera.set_as_toplevel(true)
		camera.global_transform.origin = camera.global_transform.origin.linear_interpolate(head.global_transform.origin, cam_accel * delta)
		camera.rotation.y = rotation.y
		camera.rotation.x = head.rotation.x
	else:
		camera.set_as_toplevel(false)
		camera.global_transform = head.global_transform


func _physics_process(delta):
	if is_on_floor():
		if not on_ground:
			jump_timer.start()
		gravity_vec = -get_floor_normal() * stick_amount
		on_ground = true
		jump_direction = Vector3() #resets the jump direction when the player is on the floor
	else:
		can_jump = false
		if on_ground:
			gravity_vec = Vector3()
			on_ground = false
		else:
			gravity_vec += Vector3.DOWN * gravity * delta
			
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() and can_jump:
			jump_direction = direction
			jump()
	
	
	#prevents the player from changing direction mid air
	if is_on_floor() and can_jump:
		velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
	else:
		velocity = velocity.linear_interpolate(jump_direction * speed, acceleration * delta)
		
	movement.z = velocity.z + gravity_vec.z
	movement.x = velocity.x + gravity_vec.x
	movement.y = gravity_vec.y
	movement = move_and_slide(movement, Vector3.UP)
	
func jump():
	on_ground = false
	gravity_vec = Vector3.UP * jump_height

#func _on_item_dropped(item_id):
#	print(item_id)
#	if item_id == "milk":
#		var item_instance = load(ItemDB.get_item(item_id)["scene"])
#		item_drop_pos.add_child(item_instance.instance())


func _on_JumpTimer_timeout():
	can_jump = true
