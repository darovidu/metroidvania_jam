extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var gravity:float = 1000.0
var fall_gravity:float = 1400.0

enum STATES {
	IDLE,
	WALK,
	JUMP,
	FALL
}

var current_state:STATES = STATES.IDLE


func _input(event: InputEvent) -> void:
	match current_state:
		STATES.IDLE:
			if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
				current_state = STATES.WALK
			elif Input.is_action_just_pressed("jump") and is_on_floor():
				current_state = STATES.JUMP
		STATES.WALK:
			if not Input.is_action_pressed("left") and not Input.is_action_pressed("right"):
				current_state = STATES.IDLE
			elif Input.is_action_pressed("jump"):
				current_state = STATES.JUMP

	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = JUMP_VELOCITY / 4

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		if velocity.y < 0:
			velocity.y += gravity * delta
		else:
			velocity.y += fall_gravity * delta
	
	match current_state:
		STATES.IDLE:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			$Animations.play("idle")
		STATES.WALK:
			velocity.x = Input.get_axis("left", "right") * SPEED
			$Animations.play("walk")
		STATES.JUMP:
			velocity.y = JUMP_VELOCITY
			$Animations.play("jump")
			if velocity.y > 0:
				current_state = STATES.FALL
		STATES.FALL:
			$Animations.play("fall")
			if is_on_floor():
				current_state = STATES.IDLE

	move_and_slide()
