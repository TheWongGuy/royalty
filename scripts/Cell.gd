extends Node2D

class_name Cell

enum Type {
	WATER = 2
	LAND = 1
	VILLAGE = 3
}

var location : Vector2
var type : int 
var height : int # TODO: Implement perlin noise height?
var land_mass # reference to land mass of current cell

func  _init(location : Vector2, type : int):
	self.location = location
	self.type = type
