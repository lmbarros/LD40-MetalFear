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
	initVision()
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
		yield($anim, "animation_finished")
		queue_free()
	else:
		$anim.play("hit")

func _process(delta):
	if isDying:
		return

	watch()

	if SectorState.isAlarmRinging:
		doAttack()
	else:
		doPatrol()

func doAttack():
	print("Attacking!")

func doPatrol():
	if patrol == null:
		return

	if position.distance_to(patrolTargetPoint) < patrolArrivalDistance:
		nextPatrolPoint()

	var velocity = (patrolTargetPoint - position).normalized() * speed * 0.5
	move_and_slide(velocity)
	rotation = velocity.angle() + PI/2

# ------------------------------------------------------------------------------
# Vision
# ------------------------------------------------------------------------------
func initVision():
	for i in range($vision.get_child_count()):
		var rayCast = $vision.get_child(i)
		rayCast.add_exception(self)

func watch():
	if SectorState.isAlarmRinging:
		return

	if $vision == null:
		return

	for i in range($vision.get_child_count()):
		var rayCast = $vision.get_child(i)
		rayCast.force_raycast_update()
		if rayCast.is_colliding() and rayCast.get_collider() == Player:
			SectorState.isAlarmRinging = true

