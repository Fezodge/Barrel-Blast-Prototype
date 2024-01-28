class_name Player
extends CharacterBody2D

@onready var animations = $Animations
@onready var state_machine = $StateMachine

@export var speed := 400.0
@export var jump_velocity := -700.0
@export var fall_speed := 1.1
@export var jump_buffer := 0.1
@export var jump_decay := 0.5

@export var Bullet : PackedScene

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready() -> void:
	state_machine.init(self)
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		shoot()

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	
func movement() -> void:
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	if velocity.x < 0:
		animations.flip_h = true
	elif velocity.x > 0:
		animations.flip_h = false
		
	move_and_slide()

func shoot():
	var b = Bullet.instantiate()
	owner.add_child(b)
	b.position = $Gun.global_position #Sets initial position of bullet = to player
	
	b.direction = (get_global_mouse_position() - b.position).normalized()

	
