extends RigidBody2D


var rope_class = preload("res://weapons/Rope.tscn")

func _on_Arrow_body_entered(body):
	if body is TileMap:
		var rope = rope_class.instance()
		rope.position = self.position
		get_parent().add_child(rope)
		queue_free()
