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

func _physics_process(_delta):
	pass
