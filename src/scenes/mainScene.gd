extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var gunHitFx = preload("res://scenes/fx/hit_shot.tscn")

func _ready():
	Player.connect("hitWithFirearm", self, "somethingWasHit")
	Player.connect("hitWithMelee", self, "somethingWasHit")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func somethingWasHit(what, where, weapon):
	print("Something was hit: " + what.get_name())
	var fx = gunHitFx.instance()
	fx.position = where
	add_child(fx)
	
	if what.has_method("hit"):
		what.hit(weapon)
		
	