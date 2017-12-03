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
	$attackModeTimer.connect("timeout", self, "changeAttackMode")
	$shootTimer.connect("timeout", self, "shoot")
	
	initVision()
	patrol = $patrol
	nextPatrolPoint()
	randomizeAttackMode()

func nextPatrolPoint():
	if patrol == null || patrol.get_child_count() == 0:
		return

	patrolIndex += 1
	if patrolIndex >= patrol.get_child_count():
		patrolIndex = 0
	patrolTargetPoint = patrol.get_child(patrolIndex).position

func _process(delta):
	if isDying:
		return

	watch()

	if State.isAlarmRinging:
		doAttack()
	else:
		doPatrol()

func doPatrol():
	if patrol == null:
		return

	if position.distance_to(patrolTargetPoint) < patrolArrivalDistance:
		nextPatrolPoint()

	var velocity = (patrolTargetPoint - position).normalized() * speed * 0.5
	move_and_slide(velocity)
	rotation = velocity.angle() + PI/2

# ------------------------------------------------------------------------------
# Attack
# ------------------------------------------------------------------------------
var weapon = null

export var changeAttackModeInterval = 7.0
export var shootInterval = 0.5

var randomTargetPoint = null

enum {
	attackModeWait,
	attackModeShoot,
	attackModeMoveTowardsPlayer,
	attackModeMoveRandomly,
}

var attackMode = attackModeMoveTowardsPlayer

func randomizeAttackMode():
	var r = randf()
	if r < 0.4: attackMode = attackModeShoot
	elif r < 0.7: attackMode = attackModeMoveTowardsPlayer
	elif r < 0.9: attackMode = attackModeMoveRandomly
	else: attackMode = attackModeWait

func doAttack():
	if $attackModeTimer.is_stopped():
		setAttackModeTimer()

	match (attackMode):
		attackModeWait:
			doAttackWait()
		attackModeShoot:
			doAttackShoot()
		attackModeMoveTowardsPlayer:
			doAttackMoveTowardsPlayer()
		attackModeMoveRandomly:
			doAttackMoveRandomly()

func doAttackWait():
	rotation = (Player.position - position).angle() + PI/2

func setShootTimer():
	var delta = (randf() - 0.5) * shootInterval * 0.1
	var timeForShooting = shootInterval + delta
	timeForShooting = clamp(timeForShooting, 0.05, 3600.0)
	$shootTimer.wait_time = timeForShooting
	$shootTimer.start()
	
func setAttackModeTimer():
	var delta = (randf() - 0.5) * changeAttackModeInterval * 0.1
	var timeForChanging = changeAttackModeInterval + delta
	timeForChanging = clamp(timeForChanging, 2.5, 3600.0)
	$attackModeTimer.wait_time = timeForChanging
	$attackModeTimer.start()
	
func changeAttackMode():
	$shootTimer.stop()
	randomizeAttackMode()
	setAttackModeTimer()

func doAttackShoot():
	rotation = (Player.position - position).angle() + PI/2

	if $shootTimer.is_stopped():
		setShootTimer()

func doAttackMoveTowardsPlayer():
	var velocity = (Player.position - position).normalized() * speed
	move_and_slide(velocity)
	rotation = velocity.angle() + PI/2
	
func randomizeTargetPosition():
	randomTargetPoint = Vector2(
		int(rand_range(0, State.width)),
		int(rand_range(0, State.height)))

	
func doAttackMoveRandomly():
	if randomTargetPoint == null:
		randomizeTargetPosition()

	if position.distance_to(randomTargetPoint) < patrolArrivalDistance:
		randomizeTargetPosition()

	var velocity = (randomTargetPoint - position).normalized() * speed
	move_and_slide(velocity)
	rotation = velocity.angle() + PI/2


func shoot():
	setShootTimer() # keep shooting

	var aim = (randf() - 0.5) * 0.15
	rotation = (Player.position - position).angle() + PI/2 + aim

	$shotRayCast.force_raycast_update()
	if !$shotRayCast.is_colliding():
		return
	
	var obj = $shotRayCast.get_collider()
	if obj.has_method("onHit"):
		var pos = $shotRayCast.get_collision_point()
		obj.onHit(weapon, pos)


# ------------------------------------------------------------------------------
# Vision
# ------------------------------------------------------------------------------
func initVision():
	# I want enemies to block the vision of other enemies, so I cannot simply
	# set the ray cast mask to ignore enemies.
	for i in range($vision.get_child_count()):
		var rayCast = $vision.get_child(i)
		rayCast.add_exception(self)

func watch():
	if State.isAlarmRinging:
		return

	if $vision == null:
		return

	for i in range($vision.get_child_count()):
		var rayCast = $vision.get_child(i)
		rayCast.force_raycast_update()
		if rayCast.is_colliding() and rayCast.get_collider() == Player:
			State.isAlarmRinging = true


# ------------------------------------------------------------------------------
# React to (poor man's) events
# ------------------------------------------------------------------------------
func onHit(weapon, hitPos):
	if isDying:
		return

	VFX.hitBlood(hitPos)

	health -= weapon.damage
	if health < 0.0:
		isDying = true
		layers = 0
		$anim.play("death")
		yield($anim, "animation_finished")
		queue_free()
	else:
		$anim.play("hit")
