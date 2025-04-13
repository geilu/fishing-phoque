extends CharacterBody2D


const SPEED = 150.0

# spear things for fish catching
@onready var spear: AnimatedSprite2D = $Spear
@onready var spear_collision_area: Area2D = $Spear/SpearCollisionArea
@onready var spear_collision: CollisionShape2D = $Spear/SpearCollisionArea/SpearCollision

var is_attacking = false
var spear_og_position: Vector2

func _ready():
	# spear stuff
	spear_og_position = spear.position
	spear_collision.disabled = true # disabled until attack

func _input(event):
	if event.is_action_pressed("attack") and not is_attacking:
		attack_with_spear()

func attack_with_spear():
	is_attacking = true
	spear_collision.disabled = false # enable so colliding with fish is detected during attack
	
	# spear thrust animation
	var target_position = spear_og_position + Vector2(50.0, 0) #(spear atk distance, 0)
	var tween = create_tween()
	tween.tween_property(spear, "position", target_position, 0.1) # move to target pos
	tween.tween_property(spear, "position", spear_og_position, 0.3) # move back to og pos
	tween.tween_callback(_finish_attack)

func _finish_attack():
	is_attacking = false
	spear_collision.disabled = true

func _physics_process(delta: float) -> void:
	# alwyas look at where mouse is
	look_at(get_global_mouse_position())

	# Get the input direction and handle the movement/deceleration.
	var directionX := Input.get_axis("left", "right")
	var directionY := Input.get_axis("up", "down")
	
	if directionY:
		velocity.y = directionY * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	if directionX:
		velocity.x = directionX * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
