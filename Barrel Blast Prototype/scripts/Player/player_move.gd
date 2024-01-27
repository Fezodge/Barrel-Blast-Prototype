class_name PlayerMove
extends State



func enter():
	parent.animations.play("Running")

func physics_update(delta) -> void:
	parent.movement()
	
	# Start jump.
	if Input.is_action_just_pressed("jump") and parent.is_on_floor():
		print("help")
		transitioned.emit(self, "PlayerJumping")

	# Stop moving
	if parent.velocity == Vector2(0, 0):
		transitioned.emit(self, "PlayerIdle")
