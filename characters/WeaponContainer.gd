extends Node2D


const CONTAINER_DISTANCE = 40
var current_weapon = 0
var gun_class = preload("res://weapons/Gun.tscn")
var bow_class = preload("res://weapons/Bow.tscn")

onready var weapons = get_node("Weapons")

func _ready():
	var gun  = gun_class.instance()
	var bow  = bow_class.instance()
	weapons.add_child(gun)
	weapons.add_child(bow)

func _unhandled_input(event):
	var weapons_len = weapons.get_child_count()
	if event is InputEventMouseMotion:
		set_position_from_mouse_angle()
	if event.is_action_released("switch_weapon"):
		current_weapon = (current_weapon + 1) % weapons_len
		print("current weapon ", current_weapon)

	if event.is_action_released("shoot"):
		self.shoot_to_aimed_direction()

func set_position_from_mouse_angle():
	var pos = (get_global_mouse_position() - get_parent().position).normalized() * CONTAINER_DISTANCE
	self.position = pos

func shoot_to_aimed_direction():
	var aimed_direction = (get_local_mouse_position() - self.position).normalized()
	var weapon = get_node("Weapons").get_children()[current_weapon]
	var projectile = weapon.get_projectile()
	projectile.rotation = aimed_direction.angle()
	projectile.position = get_node("..").position + self.position
	get_node("../../").add_child(projectile)
	projectile.apply_impulse(Vector2.ZERO, aimed_direction * weapon.SPEED)
