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
var rope = null
onready var PULL_SPEED = gravity
var snap_vector = Vector2.DOWN * 20

var jump_timer = Timer.new()
var bounce_timer = Timer.new()

var moving_right = false
var moving_left = false

onready var state_factory = StateFactory.new()
var state

func _unhandled_input(event):
	if event.is_action_pressed("ui_right"):
		moving_right = true
	if event.is_action_released("ui_left"):
		moving_left = true

	if event.is_action_pressed("ui_right"):
		moving_right = true
	if event.is_action_released("ui_left"):
		moving_left = false

	self.state.handle_input(event)

func change_state(state_name):
	if is_instance_valid(state):
		self.state.queue_free()
	self.state = self.state_factory.get_state(state_name).new()
	state.setup($AnimatedSprite, self)
	state.name = "current_state"
	add_child(state)

func _ready():
	jump_timer.set_wait_time(0.2)
	jump_timer.set_one_shot(true)
	jump_timer.connect("timeout", self, "_on_jump_timer_timeout")
	add_child(jump_timer)

	bounce_timer.set_wait_time(1)
	bounce_timer.set_one_shot(true)
	bounce_timer.connect("timeout", self, "_on_bounce_timer_timeout")
	add_child(bounce_timer)

	self.change_state("idle")

func _on_jump_timer_timeout():
	is_jumping = false
	velocity.y = 0.0

func _on_bounce_timer_timeout():
	is_bouncing = false

# func _physics_process(delta):
# 	var direction = get_direction()
# 	velocity = get_velocity(direction, delta)
# 	if is_jumping or self.rope:
# 		move_and_slide(velocity, Vector2.UP)
# 	else:
# 		move_and_slide_with_snap(velocity, snap_vector, Vector2.UP, false)

func get_velocity(current_direction, delta):
	var current_velocity = self.velocity
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

	if Input.is_key_pressed(KEY_T):
		print("velocity BEFORE rope pull force ", v)

	if self.rope:
		var rope_vector = to_local(self.rope.global_position)
		var rope_pull_vector = rope_vector.normalized() * (PULL_SPEED * (rope_vector.length() / self.rope.length) )
		v += rope_pull_vector

	return v

# func _unhandled_input(event):
# 	if event.is_action_pressed("shoot"):
# 		if self.rope:
# 			self.rope.queue_free()
# 			self.rope = null

func get_direction():
	var x_dir = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

	if is_bouncing:
		x_dir = bounce_x_dir

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
