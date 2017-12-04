extends KinematicBody2D

export (float, -0, 1, 0.05) var strength = 0.5

func _ready():
	State.addMagnet(position, strength)

func imMagnet():
	pass

# ------------------------------------------------------------------------------
# React to (poor man's) events
# ------------------------------------------------------------------------------
func onHit(weapon, hitPos):
	VFX.gunHit(hitPos)
