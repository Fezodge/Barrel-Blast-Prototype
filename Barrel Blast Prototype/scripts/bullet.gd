extends RigidBody2D

var speed := 1000
var direction : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var velocity: Vector2
	velocity = direction * speed * delta
	var collision = move_and_collide(velocity)

	if !$VisibleOnScreenNotifier2D.is_on_screen:
		queue_free()
		
	if collision:
		explode()
		
func explode():
	print("boom")
	queue_free()
