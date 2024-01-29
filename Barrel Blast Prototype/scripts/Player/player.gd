class_name Player
extends CharacterBody2D

@onready var animations = $Animations
@onready var state_machine = $MovementStateMachine
@onready var timer = $Gun/Timer

@export var ground_speed := 100
@export var max_ground_speed := 400
@export var deceleration := 50

@export var air_speed := 30
@export var max_air_speed := 800
@export var air_deceleration := 10

@export var jump_speed := -700.0
@export var fall_speed := 1.06

@export var jump_buffer := 0.1
@export var jump_decay := 0.5

@export var explosion_strength := 1000
var blast_velocity := Vector2.ZERO
var blast_recoil := Vector2(INF, INF)

@export var Bullet : PackedScene

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_shoot := true

func _ready() -> void:
	state_machine.init(self)
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot") and can_shoot:
		shoot()

func _physics_process(delta: float) -> void:
	#Ground speed
	var direction = get_input()
	if direction and is_on_floor():
		velocity.x += direction * ground_speed
		velocity.x = move_toward(velocity.x, 0, deceleration)
		velocity.x = clamp(velocity.x, -max_ground_speed, max_ground_speed)
	
	else:
		velocity.x += direction * air_speed
		velocity.x = move_toward(velocity.x, 0, air_deceleration)
		velocity.x = clamp(velocity.x, -max_air_speed, max_air_speed)
		
	velocity.y += gravity * delta # Applies gravity at all times
	
	velocity += blast_velocity
	
	move_and_slide()
	blast_velocity.y = move_toward(blast_velocity.y, Vector2.ZERO.y, blast_recoil.y)
	blast_velocity.x = move_toward(blast_velocity.x, Vector2.ZERO.x, blast_recoil.x)
	
	#Flip animations
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
	can_shoot = false
	timer.start()
	
func blast(zone):
	velocity = Vector2.ZERO
	var vector = global_position - zone.global_position
	var direction = vector.normalized()
	var distance_squared = vector.length()
	blast_velocity = direction * explosion_strength

func _on_timer_timeout() -> void:
	can_shoot = true
