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
var is_bouncing = false
var bounce_x_dir = 0
var is_attached_to_rope = false
var rope = null
var PULL_SPEED = 100

var jump_timer = Timer.new()
var bounce_timer = Timer.new()

func _ready():
	jump_timer.set_wait_time(0.2)
	jump_timer.set_one_shot(true)
	jump_timer.connect("timeout", self, "_on_jump_timer_timeout")
	add_child(jump_timer)

	bounce_timer.set_wait_time(0.2)
	bounce_timer.set_one_shot(true)
	bounce_timer.connect("timeout", self, "_on_bounce_timer_timeout")
	add_child(bounce_timer)

func _on_jump_timer_timeout():
	is_jumping = false
	velocity.y = 0.0

func _on_bounce_timer_timeout():
	is_bouncing = false

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
		v += (Vector2.DOWN * gravity/2) + (Vector2.DOWN * gravity * delta)

	if self.rope:
		var rope_vector = to_local(self.rope.global_position)
		if self.rope.length < rope_vector.length():
			print("length is less than vector")
			var rope_pull_vector = rope_vector.normalized() * PULL_SPEED
			# rope_pull_vector.x *= 4
			v += rope_pull_vector

	return v

func get_direction():
	var x_dir = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

	if is_bouncing:
		x_dir = bounce_x_dir

	if not is_on_floor():
		x_dir /= 4

	if Input.is_action_just_pressed("jump"):
		if self.rope:
			self.rope.queue_free()
			self.rope = null

		if (is_on_floor() or is_on_wall()) and not is_jumping:
			is_jumping = true
			jump_timer.start()

			if is_on_wall() and not is_on_floor() and get_slide_count():
				var collision = get_slide_collision(0)

				is_bouncing = true
				bounce_x_dir = collision.normal.x

				x_dir += bounce_x_dir
				bounce_timer.start()

	return Vector2(
		x_dir,
		-1 if is_jumping else 0
	).normalized()

func _process(_delta):
	update()

func _draw():
	draw_line(Vector2.ZERO, velocity.normalized() * 50, Color(1, 1, 1))
