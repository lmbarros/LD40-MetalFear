extends Area2D

export var health = 50.0

func hit(weapon):
	health -= weapon.damage
	print (health)
	if health > 0.0:
		$anim.play("hit")
	else:
		$anim.play("death")
		print("Augh!")
		yield($anim, "animation_finished")
		print("Removing")
		queue_free()
