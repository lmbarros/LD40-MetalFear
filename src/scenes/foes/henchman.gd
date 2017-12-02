extends KinematicBody2D

# If this close, we are there
const patrolArrivalDistance = 10

export var health = 50.0
export var speed = 150.0

var isDying = false
var patrol = null

var patrolIndex = -1
var patrolTargetPoint = null

func _ready():
	patrol = $patrol
	nextPatrolPoint()

func nextPatrolPoint():
	if patrol == null || patrol.get_child_count() == 0:
		return

	patrolIndex += 1
	if patrolIndex >= patrol.get_child_count():
		patrolIndex = 0
	patrolTargetPoint = patrol.get_child(patrolIndex).position

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

func _process(delta):
	if isDying:
		return

	if patrol == null:
		return

	if position.distance_to(patrolTargetPoint) < patrolArrivalDistance:
		nextPatrolPoint()

	var velocity = (patrolTargetPoint - position).normalized() * speed * 0.5
	move_and_slide(velocity)
	rotation = velocity.angle() + PI/2
	