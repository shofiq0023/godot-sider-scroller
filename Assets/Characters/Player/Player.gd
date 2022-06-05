extends KinematicBody2D

var velocity = Vector2.ZERO;
var walking = false;

const moveSpeed = 200;
const walkSpeed = 100;
const GRAVITY = 20;
const JUMPFORCE = -400;

func _ready():
	pass

# Gets input with input(type -> "run" or "walk") and direction ("left" of "right")
func input(input, dir):
	if input == "run" and dir == "right":
		velocity.x = moveSpeed;
	if input == "run" and dir == "left":
		velocity.x = -moveSpeed;
	if input == "walk" and dir == "right":
		velocity.x = walkSpeed;
	if input == "walk" and dir == "left":
		velocity.x = -walkSpeed;
		
	if dir == "right":
		$AnimatedSprite.flip_h = false;
	elif dir == "left":
		$AnimatedSprite.flip_h = true;
	
	getAnimation();

# Plays animation
func getAnimation():
	if is_on_floor():
		if velocity.x == 0:
			$AnimatedSprite.play("Idle");
		if walking == false:
			if (velocity.x > 0) or (velocity.x < 0):
				$AnimatedSprite.play("Running");
		if walking == true:
			if (velocity.x > 0) or (velocity.x < 0):
				$AnimatedSprite.play("Walking");
	
	if not is_on_floor():
		if velocity.y < 0:
			$AnimatedSprite.play("Jumping");
		if velocity.y > 0:
			$AnimatedSprite.play("Falling")

# Gets user input
func getInput():
	if walking == false:
		if Input.is_action_pressed("right"):
			input("run", "right");
		elif Input.is_action_pressed("left"):
			input("run", "left");
		else:
			velocity.x = 0;
			getAnimation();
	elif walking == true:
		if Input.is_action_pressed("right"):
			input("walk", "right");
		elif Input.is_action_pressed("left"):
			input("walk", "left");
		else:
			velocity.x = 0;
			getAnimation();
	
	# Toggle walk (CapsLock)
	if Input.is_action_just_pressed("walk"):
		walking = !walking;
	
	# Can jump if only on floor (means no double jump)
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMPFORCE;
			getAnimation();

# Main game function
func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY;
	
	getInput();
	
	velocity.x = lerp(velocity.x, 0, 0.2);
	velocity = move_and_slide(velocity, Vector2.UP);

func _on_Area2D_body_entered(body: Node) -> void:
	get_tree().change_scene("res://Scene/Main.tscn");
