extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	Player.connect("hitWithGun", self, "somethingWasHit")
	Player.connect("hitWithGun", self, "somethingWasHit")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func somethingWasHit(what):
	print("Something was hit: " + what.get_name())