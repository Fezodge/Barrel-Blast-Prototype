class_name PlayerRunning
extends State


func enter():
	parent.animations.play("Running")

func physics_update(delta) -> void:
	
	# Start jump.
	if Input.is_action_pressed("jump") and parent.is_on_floor():
		transitioned.emit(self, "PlayerJumping")
	elif !parent.is_on_floor():
		transitioned.emit(self, "PlayerAirborne")

	# Stop moving
	if parent.velocity == Vector2(0, 0):
		transitioned.emit(self, "PlayerIdle")

	if parent.velocity.y > 0:
		transitioned.emit(self, "PlayerFalling")	

