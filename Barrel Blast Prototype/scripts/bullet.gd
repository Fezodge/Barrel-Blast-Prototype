extends RigidBody2D

var speed := 1500
var direction : Vector2
var velocity: Vector2
@export var Explosion : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocity = direction * speed * delta
	
	var collision = move_and_collide(velocity)

	if !$VisibleOnScreenNotifier2D.is_on_screen:
		queue_free()
		
	if collision:
		explode()
		
func explode():
	var e = Explosion.instantiate()
	get_parent().add_child(e)
	e.global_position = self.global_position #Sets initial position of bullet = to player

	self.queue_free()
