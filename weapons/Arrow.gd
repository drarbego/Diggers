extends RigidBody2D


var rope_class = preload("res://weapons/Rope.tscn")

# esto no funcionará para multijugador
onready var triggerer = get_node("/root/Maze/ControllableCharacter")


func _on_Arrow_body_entered(body):
	if body is TileMap:
		var rope = rope_class.instance()
		rope.global_position = self.global_position
		rope.triggerer = self.triggerer
		rope.to_pos = get_global_mouse_position()
		# TODO pass reference to character
		get_parent().add_child(rope)
		triggerer.change_state("rope")
		queue_free()
