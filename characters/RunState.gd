extends State

class_name RunState

var move_speed = Vector2(180, 0)
var min_move_speed = 0.005
var friction = 0.32

func _ready():
	print("RUN")

func handle_input(_event):
	if not (self.persistent_state.moving_left or self.persistent_state.moving_right):
		self.persistent_state.change_state("idle")

func _physics_process(delta):
	if Input.is_action_just_pressed("jump") and self.persistent_state.is_on_floor():
		self.persistent_state.change_state("jump")

	var direction = self.get_direction()
	self.persistent_state.velocity = self.get_velocity(direction, delta)
	self.persistent_state.move_and_slide_with_snap(self.persistent_state.velocity, self.persistent_state.snap_vector, Vector2.UP, false)

func get_velocity(current_direction, delta):
	var current_velocity = self.persistent_state.velocity
	var v = current_velocity
	v.x = current_direction.x * self.persistent_state.SPEED

	if self.persistent_state.is_on_floor():
		v.y = 0.0
	elif v.y >= self.persistent_state.MAX_FALL_SPEED:
		v.y = self.persistent_state.MAX_FALL_SPEED
	else:
		v += (Vector2.DOWN * self.persistent_state.gravity/2) + (Vector2.DOWN * self.persistent_state.gravity * delta)

	if Input.is_key_pressed(KEY_T):
		print("velocity BEFORE rope pull force ", v)

	return v

func get_direction():
	var x_dir = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

	if self.persistent_state.is_bouncing:
		x_dir = self.persistent_state.bounce_x_dir

	return Vector2(
		x_dir,
		-1 if self.persistent_state.is_jumping else 0
	).normalized()
