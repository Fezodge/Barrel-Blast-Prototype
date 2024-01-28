class_name Player
extends CharacterBody2D

@onready var animations = $Animations
@onready var state_machine = $StateMachine

@export var max_speed := 400
@export var speed := 100
@export var deceleration := 50
@export var jump_speed := -700.0
@export var fall_speed := 1.1

@export var jump_buffer := 0.1
@export var jump_decay := 0.5

@export var explosion_strength := 1000
var blast_velocity := Vector2.ZERO
var blast_recoil := Vector2(900000000, 900000000)

@export var Bullet : PackedScene

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready() -> void:
	state_machine.init(self)
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		shoot()

func _physics_process(delta: float) -> void:
	var direction = get_input()
	if direction:
		velocity.x += direction * speed
		velocity.x = clamp(velocity.x, -max_speed, max_speed)
	velocity.y += gravity * delta # Applies gravity at all times
	
	velocity += blast_velocity
	
	move_and_slide()
	blast_velocity.y = move_toward(blast_velocity.y, Vector2.ZERO.y, blast_recoil.y)
	blast_velocity.x = move_toward(blast_velocity.x, Vector2.ZERO.x, blast_recoil.x)
	
	velocity.x = move_toward(velocity.x, 0, deceleration)
	
	if velocity.x < 0:
		animations.flip_h = true
	elif velocity.x > 0:
		animations.flip_h = false

func get_input():
	return Input.get_axis("left", "right")

func shoot():
	var b = Bullet.instantiate()
	owner.add_child(b)
	b.global_position = $Gun.global_position #Sets initial position of bullet = to player
	
	b.direction = (get_global_mouse_position() - b.global_position).normalized()

func blast(zone):
	var vector = global_position - zone.global_position
	var direction = vector.normalized()
	var distance_squared = vector.length()
	blast_velocity = direction * explosion_strength
