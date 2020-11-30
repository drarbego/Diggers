extends Node2D


const CONTAINER_DISTANCE = 40
var current_weapon = 0
var gun_class = preload("res://weapons/Gun.tscn")

func _ready():
	var gun  = gun_class.instance()
	get_node("Weapons").add_child(gun)

func _unhandled_input(event):
	var weapons_len = get_child_count()
	if event is InputEventMouseMotion:
		set_position_from_mouse_angle()
	if event.is_action_released("switch_weapon"):
		current_weapon = (current_weapon + 1) % weapons_len

	if event.is_action_released("shoot"):
		self.shoot_to_aimed_direction()

func set_position_from_mouse_angle():
	var pos = (get_global_mouse_position() - get_parent().position).normalized() * CONTAINER_DISTANCE
	self.position = pos

func shoot_to_aimed_direction():
	var aimed_direction = (get_local_mouse_position() - self.position).normalized()
	var weapon = get_node("Weapons").get_children()[current_weapon]
	var bullet = weapon.get_bullet()
	bullet.position = get_node("..").position + self.position
	get_node("../../").add_child(bullet)
	bullet.apply_impulse(Vector2.ZERO, aimed_direction * weapon.SPEED)
