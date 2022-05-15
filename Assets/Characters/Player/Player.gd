extends KinematicBody2D

var velocity = Vector2.ZERO;
var title = "Game v1"

const moveSpeed = 200;
const GRAVITY = 20;
const JUMPFORCE = -400;

func _ready():
	pass

func getAnimation():
	if is_on_floor():
		if velocity.x == 0:
			$AnimatedSprite.play("Idle");
		if (velocity.x > 0) or (velocity.x < 0):
			$AnimatedSprite.play("Running");
	
	if not is_on_floor():
		if velocity.y < 0:
			$AnimatedSprite.play("Jump");
		if velocity.y > 0:
			$AnimatedSprite.play("Fall")

func getInput():
	if Input.is_action_pressed("right"):
		velocity.x = moveSpeed;
		getAnimation();
		$AnimatedSprite.flip_h = false;
	elif Input.is_action_pressed("left"):
		velocity.x = -moveSpeed;
		getAnimation();
		$AnimatedSprite.flip_h = true;
	else:
		velocity.x = 0;
		getAnimation();
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMPFORCE;
			getAnimation();

func _process(delta):
	OS.set_window_title(title + " | fps: " + str(Engine.get_frames_per_second()));
	velocity.y += GRAVITY;
	
	getInput();
	
	velocity.x = lerp(velocity.x, 0, 0.2);
	velocity = move_and_slide(velocity, Vector2.UP);
