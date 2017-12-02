extends KinematicBody2D

signal hitWithFirearm
signal hitWithMelee

onready var screenSize = get_viewport_rect().size

var speed = 200
var magnetSpeed = 100 # base speed induced by magnet
var velocity = Vector2()

# The carried weapons
var arsenal = [ Weapons.fist, Weapons.pistol ]

# The index of the currently selected weapon
var weaponIndex = 0

func currWeapon():
	return arsenal[weaponIndex]

func _ready():
	# Don't shoot yourself (in the foot or otherwise)
	# (Why doesn't "ignore parent" work here?)
	$shotRayCast.add_exception(Player)
	$meleeRayCast1.add_exception(Player)
	$meleeRayCast2.add_exception(Player)
	$meleeRayCast3.add_exception(Player)

func nextWeapon():
	weaponIndex += 1
	if weaponIndex >= arsenal.size():
		weaponIndex = 0
	updateWeapon()

func prevWeapon():
	weaponIndex -= 1
	if weaponIndex < 0:
		weaponIndex = arsenal.size() - 1
	updateWeapon()

func updateWeapon():
	match currWeapon():
		Weapons.fist:
			$sprite/weapon.animation = "fistIdle"
		Weapons.pistol:
			$sprite/weapon.animation = "pistolIdle"

func _process(delta):
	velocity = Vector2()

	# Walk
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		
	# Rotate before magnet influence
	if velocity.length_squared() > 0:
		rotation = velocity.angle() + PI/2

	# Magnets
	velocity += SectorState.magnetAttraction(position) * magnetSpeed

	# Move!
	move_and_slide(velocity)
	
	# Switch weapons
	if Input.is_action_just_pressed("next_weapon"):
		nextWeapon()
	elif Input.is_action_just_pressed("prev_weapon"):
		prevWeapon()

	# Shoot
	if Input.is_action_just_pressed("attack"):
		if currWeapon().type == Weapons.melee:
			meleeAttack()
		else:
			firearmAttack()

func meleeAttackHelper(rayCast):
	rayCast.force_raycast_update()
	if rayCast.is_colliding():
		emit_signal("hitWithMelee", rayCast.get_collider(),
			rayCast.get_collision_point(),
			currWeapon())

func meleeAttack():
	if meleeAttackHelper($meleeRayCast2):
		return
	if meleeAttackHelper($meleeRayCast1):
		return
	if meleeAttackHelper($meleeRayCast3):
		return
	
func firearmAttack():
	$shotRayCast.force_raycast_update()
	
	if $shotRayCast.is_colliding():
		emit_signal("hitWithFirearm", $shotRayCast.get_collider(),
			$shotRayCast.get_collision_point(),
			currWeapon())
