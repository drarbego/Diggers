extends Node2D


var current_weapon = 0

func _unhandled_input(event):
	var weapons_len = get_child_count()
	if event.is_action_released("switch_weapon"):
		current_weapon = (current_weapon + 1) % weapons_len

	if event.is_action_released("shoot"):
		self.shoot_to_aimed_direction()

func shoot_to_aimed_direction():
	var aimed_direction = (get_local_mouse_position() - self.position).normalized()
	var weapon = get_children()[current_weapon]
	print(weapon)
	var bullet = weapon.get_bullet()
	bullet.position = get_node("..").position + self.position
	get_node("../../").add_child(bullet)
	bullet.apply_impulse(Vector2.ZERO, aimed_direction * weapon.SPEED)
