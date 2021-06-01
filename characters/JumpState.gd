extends State

class_name JumpState

# TODO set timer to stop jump force, stop jump on collision
var JUMP_TIME = 0.2
var timer = Timer.new()

func _ready():
	print("jump state")
	timer.set_wait_time(JUMP_TIME)
	timer.connect("timeout", self, "_on_timer_timeout")
	timer.set_autostart(true)
	timer.set_one_shot(true)
	self.add_child(timer)

func _on_timer_timeout():
	print("timeout")
	if Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left") != 0:
		self.persistent_state.change_state("run")
	else:
		self.persistent_state.change_state("idle")

func _physics_process(delta):
	var direction = self.get_direction()
	self.persistent_state.velocity = self.get_velocity(direction, delta)
	self.persistent_state.move_and_slide(self.persistent_state.velocity, Vector2.UP)

func get_direction():
	var x_dir = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	return Vector2(x_dir, -1).normalized()

func get_velocity(current_direction, _delta):
	return current_direction * self.persistent_state.jump_speed
