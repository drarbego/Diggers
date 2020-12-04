extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _on_DetectionArea_body_entered(body):
	if body is ControllableCharacter:
		body.is_attached_to_rope = true
		body.rope = $RigidBody2D4/DetectionArea

func _on_DetectionArea_body_exited(body):
	if body is ControllableCharacter:
		body.is_attached_to_rope = false
		body.rope = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
