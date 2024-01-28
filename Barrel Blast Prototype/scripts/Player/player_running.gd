class_name PlayerRunning
extends State


func enter():
	parent.animations.play("Running")

func physics_update(delta) -> void:
	
	# Start jump.
	if !parent.is_on_floor():
		transitioned.emit(self, "PlayerJumping")

	# Stop moving
	if parent.velocity == Vector2(0, 0):
		transitioned.emit(self, "PlayerIdle")

	if parent.velocity.y > 0:
		transitioned.emit(self, "PlayerFalling")	

