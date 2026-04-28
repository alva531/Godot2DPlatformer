extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var speed = 250.0
@export_range(0, 1) var deceleration = 0.1

@export var jumpForce = -400.0
@export_range(0, 1) var decelerateOnJumpRelease = 0.5

@onready var coyoteTimer: Timer = $CoyoteTimer
var coyoteTimeActivated: bool = false


func _physics_process(delta: float) -> void:
	
	# Add animation
	if velocity.x > 1 or velocity.x < -1:
		animated_sprite_2d.animation = "run"
	else:
		animated_sprite_2d.animation = "idle"
		
	if is_on_floor():
		if coyoteTimeActivated:
			coyoteTimeActivated = false
			coyoteTimer.stop()
			
	else:
		animated_sprite_2d.animation = "jump"
		if !coyoteTimeActivated:
			coyoteTimer.start()
			coyoteTimeActivated = true
			
		velocity += get_gravity() * delta
		
			
	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		$JumpBufferTimer.start()
	
	if (!coyoteTimer.is_stopped() or is_on_floor()) and !$JumpBufferTimer.is_stopped():
		velocity.y = jumpForce
		coyoteTimer.stop()
		coyoteTimeActivated = true
		
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= decelerateOnJumpRelease

	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed * deceleration)

	move_and_slide()
	
	if direction == 1.0:
		animated_sprite_2d.flip_h = false
	elif direction == -1.0:
		animated_sprite_2d.flip_h = true
