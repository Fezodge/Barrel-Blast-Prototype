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
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("shoot") and can_shoot:
		shoot()

func _physics_process(delta: float) -> void:
	flip_animations()
	velocity.y += gravity * delta # Applies gravity at all times
	
	if is_on_floor(): #Ground speed velocity
		ground_movement()
	else: #Air speed velocity
		air_movement()
		
	explosion_movement()
	
	move_and_slide()
	

func ground_movement() -> void:
	var direction = get_input()
	velocity.x += direction * ground_speed #* delta
	velocity.x = move_toward(velocity.x, 0, deceleration)
	velocity.x = clamp(velocity.x, -max_ground_speed, max_ground_speed)
	
func air_movement() -> void:
	var direction = get_input()
	velocity.x += direction * air_speed #* delta
	velocity.x = move_toward(velocity.x, 0, air_deceleration)
	velocity.x = clamp(velocity.x, -max_air_speed, max_air_speed)
	
func explosion_movement() -> void:
	velocity += blast_velocity # Adds explosion knockback - should be 0 until explosion
	
	#Decays explosion kockback towards zero
	blast_velocity.y = move_toward(blast_velocity.y, Vector2.ZERO.y, blast_recoil.y)
	blast_velocity.x = move_toward(blast_velocity.x, Vector2.ZERO.x, blast_recoil.x)
		
		
func flip_animations() -> void:
	if velocity.x < 0:
		animations.flip_h = true
	elif velocity.x > 0:
		animations.flip_h = false

func get_input() -> float:
	return Input.get_axis("left", "right")

func shoot() -> void:
	var b = Bullet.instantiate()
	owner.add_child(b) # Owner makes it a child of root instead of the player
	b.global_position = $Gun.global_position #Sets initial position of bullet = to player
	b.direction = (get_global_mouse_position() - b.global_position).normalized()
	can_shoot = false
	timer.start()
	
func blast(zone: Area2D) -> void:
	velocity = Vector2.ZERO # Prevents the player from gaining infinite velocity
	var vector = self.global_position - zone.global_position # Finds the vector pointing fromt the explosion to the player
	var direction = vector.normalized()
	blast_velocity = direction * explosion_strength

func _on_timer_timeout() -> void:
	can_shoot = true
