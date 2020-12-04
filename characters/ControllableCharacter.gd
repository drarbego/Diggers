extends KinematicBody2D

class_name ControllableCharacter


const SPEED = 500
var MAX_FALL_SPEED = 1000
var movement_dir = Vector2()
var x_axis = 0
var y_axis = 0
var velocity = Vector2.ZERO
onready var gravity = ProjectSettings.get("physics/2d/default_gravity") 
var can_jump = true
var jump_speed = 2000
var is_jumping = false
var is_attached_to_rope = false
var rope = null

var jump_timer = Timer.new()

func _ready():
	jump_timer.set_wait_time(0.2)
	jump_timer.set_one_shot(true)
	jump_timer.connect("timeout", self, "_on_jump_timer_timeout")
	add_child(jump_timer)

func _on_jump_timer_timeout():
	is_jumping = false
	velocity.y = 0.0

func _physics_process(delta):
	var direction = get_direction()
	velocity = get_velocity(velocity, direction, delta)
	var snap_vector = Vector2.DOWN * 20
	if is_jumping:
		move_and_slide(velocity, Vector2.UP)
	elif is_attached_to_rope:
		move_and_slide((rope.global_position - self.global_position).normalized() * SPEED)
	else:
		move_and_slide_with_snap(velocity, snap_vector, Vector2.UP, false)

func get_velocity(current_velocity, current_direction, delta):
	var v = current_velocity
	v.x = current_direction.x * SPEED

	if is_jumping:
		v.y = current_direction.y * jump_speed
	elif is_on_floor():
		v.y = 0.0
	elif v.y >= MAX_FALL_SPEED:
		v.y = MAX_FALL_SPEED
	else:
		# v += Vector2.DOWN * gravity * delta
		v += (Vector2.DOWN * gravity/2) + (Vector2.DOWN * gravity * delta)

	return v

func get_direction():
	if Input.is_action_just_pressed("jump") and is_on_floor() and not is_jumping:
		is_jumping = true
		jump_timer.start()

	return Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		-1 if is_jumping else 0
	).normalized()

func _process(_delta):
	update()

func _draw():
	draw_line(Vector2.ZERO, velocity.normalized() * 50, Color(1, 1, 1))
