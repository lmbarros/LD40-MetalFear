extends "res://scenes/sectors/base_sector.gd"

func _ready():
	if Player.justStarting:
		Player.justStarting = false
		enablePortals(null)
		Player.position = $startingPoint.position
		Player.rotation = PI/2

func goToB1(body):
	rightToSector("b1")

func enablePortals(body):
	$portalB1.monitoring = true
