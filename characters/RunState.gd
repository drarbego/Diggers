extends State

class_name RunState

var move_speed = Vector2(180, 0)
var min_move_speed = 0.005
var friction = 0.32

func _ready():
    print("RUN")

func _physics_process(_delta):
    pass
