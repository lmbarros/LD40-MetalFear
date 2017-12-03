extends Node

enum { melee, firearm }


var fist = {
	type = melee,
	damage = PI, # :-)
	metal = 0.0,
	noise = 0.0,
}

var pistol = {
	type = firearm,
	damage = 15.0,
	metal = 1.1,
	noise = 0.15,
}
