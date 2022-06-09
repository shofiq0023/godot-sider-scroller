extends KinematicBody2D

onready var _anim = $AnimationPlayer;
onready var _player = $Sprite;
var velocity = Vector2.ZERO;
var isAttacking = false;

const moveSpeed = 200;
const walkSpeed = 100;
const GRAVITY = 20;
const JUMPFORCE = -400;

func getAnimation():
	if is_on_floor():
		if velocity.x == 0 and not isAttacking:
			_anim.play("Idle");
		if velocity.x > 0 and not isAttacking:
			_anim.play("Running");
			_player.scale.x = 1;
		if velocity.x < 0 and not isAttacking:
			_anim.play("Running");
			_player.scale.x = -1;
		if isAttacking:
			_anim.play("Attack");
		
	if not is_on_floor():
		if velocity.y < 0:
			_anim.play("Jumping");
		elif velocity.y > 0:
			_anim.play("Falling");

func getInput():
	if Input.is_action_pressed("left"):
		velocity.x = -moveSpeed;
		getAnimation();
	elif Input.is_action_pressed("right"):
		velocity.x = moveSpeed;
		getAnimation();
	elif Input.is_action_just_pressed("attack"):
		isAttacking = true;
		getAnimation();
	else:
		velocity.x = 0;
		getAnimation();
	
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMPFORCE;
			getAnimation();

func _physics_process(delta):
	velocity.y += GRAVITY;
	
	getInput();
	
	velocity.x = lerp(velocity.x, 0, 0.2);
	velocity = move_and_slide(velocity, Vector2.UP);


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Attack":
		isAttacking = false;
