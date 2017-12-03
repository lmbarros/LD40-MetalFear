extends KinematicBody2D

onready var screenSize = get_viewport_rect().size

var speed = 200
var magnetSpeed = 100 # base speed induced by magnet
var velocity = Vector2()
var health = 50.0

# The carried weapons
var arsenal = [ Weapons.fist, Weapons.pistol ]

# The index of the currently selected weapon
var weaponIndex = 0

func currWeapon():
	return arsenal[weaponIndex]

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

func attackHelper(rayCast):
	rayCast.force_raycast_update()
	if !rayCast.is_colliding():
		return false

	var obj = rayCast.get_collider()
	if obj.has_method("onHit"):
		var pos = rayCast.get_collision_point()
		obj.onHit(currWeapon(), pos)

	return true

func meleeAttack():
	if attackHelper($meleeRayCast2):
		return
	if attackHelper($meleeRayCast1):
		return
	if attackHelper($meleeRayCast3):
		return
	
func firearmAttack():
	attackHelper($shotRayCast)

# ------------------------------------------------------------------------------
# React to (poor man's) events
# ------------------------------------------------------------------------------
func onHit(weapon, hitPos):
	VFX.hitBlood(hitPos)
	health -= weapon.damage
	if health <= 0:
		print("GAME OVER")

