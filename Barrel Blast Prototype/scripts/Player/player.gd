class_name Player
extends CharacterBody2D

@onready var animations = $Animations
@onready var state_machine = $StateMachine

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var speed = 400.0
@export var jump_velocity = -600.0
@export var fall_speed = 6000

func _ready() -> void:
	state_machine.init(self)
	
func _process(delta: float) -> void:
	if velocity.x < 0:
		animations.flip_h = true
	elif velocity.x > 0:
		animations.flip_h = false

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	
func movement() -> void:
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	move_and_slide()

