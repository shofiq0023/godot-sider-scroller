extends Area2D

var hit = false;

func _physics_process(delta):
	if hit == true:
		$AnimatedSprite.play("Hit");
	else:
		$AnimatedSprite.play("Idle");
		
func _on_Goblin_area_entered(area):
	if area.is_in_group("Sword"):
		hit = true;

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "Hit":
		hit = false;
