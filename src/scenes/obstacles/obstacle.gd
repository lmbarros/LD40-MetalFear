extends StaticBody2D

# ------------------------------------------------------------------------------
# React to (poor man's) events
# ------------------------------------------------------------------------------
func onHit(weapon, hitPos):
	VFX.gunHit(hitPos)
