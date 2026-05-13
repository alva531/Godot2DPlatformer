extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var coyoteTimer: Timer = $CoyoteTimer
@onready var jumpBufferTimer: Timer = $JumpBufferTimer

var coyoteTimeActivated: bool = false

@export var jumpHeight: float = -250.0
@export var gravity: float = 12.0
@export var maxGravity: float = 14.5
@export var speed: float = -250.0

@export var maxSpeed: float = 100
@export var acceleration: float = 8
@export var friction: float = 10

func _ready() -> void:
	add_to_group("player")
	set_collision_mask_value(5, true)
	if RoomChangeGlobal.activate:
		global_position = RoomChangeGlobal.playerPos
		if RoomChangeGlobal.playerJumpOnEnter:
			velocity.y = jumpHeight
		RoomChangeGlobal.activate = false

func _physics_process(delta: float) -> void:
	var x_input: float = Input.get_action_strength("right") - Input.get_action_strength("left")
	var velocityWeight: float = delta * (acceleration if x_input else friction)
	velocity.x = lerp(velocity.x, x_input * maxSpeed, velocityWeight)
	
	if Input.is_action_pressed("right"):
		$AnimatedSprite2D.flip_h = false
	elif Input.is_action_pressed("left"):
		$AnimatedSprite2D.flip_h = true
	
	
	if is_on_floor():
		coyoteTimeActivated = false
		gravity = lerp(gravity, 12.0, 12.0 * delta)
		if x_input != 0:
			animated_sprite_2d.animation = "run"
		else:
			animated_sprite_2d.animation = "idle"
			
		if Input.is_action_just_pressed("down"):
			set_collision_mask_value(5, false)
			await get_tree().create_timer(0.2).timeout
			set_collision_mask_value(5, true)
			
	else:
		animated_sprite_2d.animation = "jump"
		if coyoteTimer.is_stopped() and !coyoteTimeActivated:
			coyoteTimer.start()
			coyoteTimeActivated = true
		
		if Input.is_action_just_pressed("jump") or is_on_ceiling():
			velocity.y *= 0.5
			
		gravity = lerp(gravity, maxGravity, 12.0 * delta)
	
	if Input.is_action_just_pressed("jump"):
		if jumpBufferTimer.is_stopped():
			jumpBufferTimer.start()
			
	if !jumpBufferTimer.is_stopped() and (!coyoteTimer.is_stopped() or is_on_floor()):
		velocity.y = jumpHeight
		jumpBufferTimer.stop()
		coyoteTimer.stop()
		coyoteTimeActivated = true
	elif velocity.y < 0.0:
		if Input.is_action_just_released("jump"):
			velocity.y *= 0.5
		
	if velocity.y < jumpHeight/2.0:
		var headCollision: Array = [$Left_HeadNudge.is_colliding(), $Left_HeadNudge2.is_colliding(), $Right_HeadNudge.is_colliding(), $Right_HeadNudge2.is_colliding()]
		if headCollision.count(true) == 1:
			if headCollision[0]:
				global_position.x += 1.75
			if headCollision[2]:
				global_position.x -= 1.75
				
	if velocity.y > -30 and velocity.y < -5 and abs(velocity.x) > 3:
		if $Left_LedgeHop.is_colliding() and !$Left_LedgeHop2.is_colliding() and velocity.x < 0:
			velocity.y += jumpHeight/3.25
		if $Right_LedgeHop.is_colliding() and !$Right_LedgeHop2.is_colliding() and velocity.x > 0:
			velocity.y += jumpHeight/3.25
		
	velocity.y += gravity
	
	move_and_slide()
