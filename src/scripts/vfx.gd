extends Node

onready var hitBlood = preload("res://scenes/vfx/hit_blood.tscn")

onready var gunHitFx = preload("res://scenes/vfx/hit_shot.tscn")


func gunHit(pos):
	var fx = gunHitFx.instance()
	fx.position = pos
	get_tree().get_current_scene().add_child(fx)


func hitBlood(pos):
	var fx = hitBlood.instance()
	fx.position = pos
	get_tree().get_current_scene().add_child(fx)
