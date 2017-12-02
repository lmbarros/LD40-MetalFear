extends Area2D

export var health = 50.0

var isDying = false

func hit(weapon):
	if isDying:
		return

	health -= weapon.damage
	if health < 0.0:
		isDying = true
		$anim.play("death")
		print("Augh!")
		yield($anim, "animation_finished")
		print("Removing")
		queue_free()
	else:
		$anim.play("hit")
