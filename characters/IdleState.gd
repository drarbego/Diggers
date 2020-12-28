extends State

class_name IdleState

func _ready():
	print("IDLE")

func handle_input(_event):
	if self.persistent_state.moving_left or self.persistent_state.moving_right:
		self.persistent_state.change_state("run")

func _physics_process(delta):
	self.persistent_state.velocity = self.get_velocity(delta)
	self.persistent_state.move_and_slide_with_snap(self.persistent_state.velocity, self.persistent_state.snap_vector, Vector2.UP, false)

func get_velocity(delta):
	var current_velocity = self.persistent_state.velocity
	var v = current_velocity

	v += (Vector2.DOWN * self.persistent_state.gravity/2) + (Vector2.DOWN * self.persistent_state.gravity * delta)
	if v.y >= self.persistent_state.MAX_FALL_SPEED:
		v.y = self.persistent_state.MAX_FALL_SPEED

	return v
