extends KinematicBody2D

export (float, -0, 1, 0.05) var strength = 0.5

func _ready():
	SectorState.addMagnet(position, strength)
