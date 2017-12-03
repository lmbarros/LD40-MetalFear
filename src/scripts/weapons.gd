extends Node

enum { melee, firearm }


var fist = {
	type = melee,
	damage = PI, # :-)
	metal = 0.0,
	noise = 0.0,
}

var knife = {
	type = melee,
	damage = 9.5,
	metal = 0.5,
	noise = 0.0,
}

var pistol = {
	type = firearm,
	damage = 17.0,
	metal = 1.3,
	noise = 0.15,
}

var rifle = {
	type = firearm,
	damage = 60.0,
	metal = 2.7,
	noise = 0.3,
}
