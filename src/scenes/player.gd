extends Area2D

var speed = 200
var velocity = Vector2()
onready var screenSize = get_viewport_rect().size

signal hitWithGun

func _ready():
	# Don't shoot yourself (in the foot or otherwise)
	# (Why doesn't "ignore parent" work here?)
	$shotRayCast.add_exception(Player)

func _process(delta):
	# Walk
	velocity = Vector2()
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
		
	position += velocity * delta
	position.x = clamp(position.x, 0, screenSize.x)
	position.y = clamp(position.y, 0, screenSize.y)
	
	if velocity.length_squared() > 0:
		rotation = velocity.angle() + PI/2
	
	# Shoot
	if Input.is_action_just_pressed("shoot"):
		$shotRayCast.force_raycast_update()
		
		if $shotRayCast.is_colliding():
			emit_signal("hitWithGun", $shotRayCast.get_collider(), $shotRayCast.get_collision_point())
			print("BANG! " + $shotRayCast.get_collider().get_name())
